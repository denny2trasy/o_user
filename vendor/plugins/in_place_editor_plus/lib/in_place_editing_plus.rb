module InPlaceEditingPlus
  class << self
    def included(base)
      base.extend(ClassMethods)
    end

    def format(text, methods = "")
      methods.to_s.split(".").uniq.each do |m|
        text = text.try(m)
      end
      text or "<span style='color:gray'>click to edit...</span>"
    end

    def format_for_return_text(collection)
      collection = [false, true] if collection.nil?
      c = reset_collection(collection)
      c.each do |t|
        t[0] = combine_value_and_text(t.first, t.last) if t.class==Array and t.size==2
      end
      c
    end

    def combine_value_and_text(value, text)
      value == text ? value :  "DropDownListItem[#{value}][#{text}]"
    end

    def reset_collection(collection=nil)
      #change order of item to [value, text]
      return [] if collection.nil?
      c = []
      collection.each{|t| c << ([t].flatten.map(&:class) == [String, Fixnum] ? [t.last, t.first] : t)}
	    c
    end

    def find_text_by_value(collection, value)
      collection = reset_collection(collection)
      collection.each do |t|
        return t if t == value
        return t.last if t.class==Array and t.size==2 and t.first == value
      end
      value
    end
  end

  module ClassMethods
    def in_place_edit_for(object, *attributes)
      attributes.each do |attribute|
        define_method("set_#{object}_#{attribute}") do
          @item = object.to_s.camelize.constantize.find(params[:id])
          if params[:value] =~ /^DropDownListItem\[(.+)\]\[(.+)\]$/
            value, text = $1, $2
          else
            value, text = params[:value], InPlaceEditingPlus.format(params[:value], params[:formats])
          end
          @item.update_attribute(attribute, value)
          render :text => text
        end

        define_method("get_#{object}_#{attribute}") do
          @item = object.to_s.camelize.constantize.find(params[:id])
          render :text => @item.send(attribute).to_s
        end
      end
    end
  end
end

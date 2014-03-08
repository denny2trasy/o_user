def generate_example_url
  "http://www.example.com/#{rand(10000)}"
end

def generate_example_url_with_args
  "#{example_url}?q=args"
end

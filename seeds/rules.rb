# HTML rules
app.source
  .select { |item| item.extensions.include?("html") }
  .each   { |item| item.route = item.id }
  .each   { |item| item.layout = "default" }
  .each   { |item| item.transform }

# CSS rules
app.source
  .select { |item| item.extensions.include?("scss") }
  .reject { |item| item.basename[0] == "_" }
  .each   { |item| item.route = "/styles/#{item.basename}.css" }
  .each   { |item| item.transform }

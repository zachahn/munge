app.source
  .select { |item| item.id == "index" }
  .each   { |item| item.route = "/" }
  .each   { |item| item.layout = "default" }
  .each   { |item| item.transform }

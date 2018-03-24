require "lita"

Lita.load_locales Dir[File.expand_path(
  File.join("..", "..", "locales", "*.yml"), __FILE__
)]

require "lita/handlers/cb_response_embedded"

Lita::Handlers::CbResponseEmbedded.template_root File.expand_path(
  File.join("..", "..", "templates"),
 __FILE__
)

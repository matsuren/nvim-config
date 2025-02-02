;; extends
; Add TODO: FIXME: highlight in doc-strings
(module
  .
  (comment)*
  .
  (expression_statement
    (string
      (string_content) @injection.content))
  (#set! injection.language "comment"))

(class_definition
  body: (block
    .
    (expression_statement
      (string
      (string_content) @injection.content)))
  (#set! injection.language "comment"))

(function_definition
  body: (block
    .
    (expression_statement
      (string
      (string_content) @injection.content)))
  (#set! injection.language "comment"))

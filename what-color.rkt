#lang racket

(require db
         forms
         web-server/servlet
         web-server/servlet-env)

(define dbc
  (sqlite3-connect #:database "colornames.db"))

(define (save-colorname r g b colorname)
  (query-exec dbc "INSERT INTO colornames VALUES ($1, $2, $3, $4)" r g b colorname))

(define color-form
  (let ([ensure-rgb (ensure binding/number (required) (range/inclusive 0 255))])
    (form* ([r ensure-rgb]
            [g ensure-rgb]
            [b ensure-rgb]
            [name (ensure binding/text (required) (longer-than 1) (shorter-than 41))])
           (list r g b name))))

(define (respond-with txt)
  (response/output
   #:code 200
   #:mime-type #"text/plain; charset=utf-8"
   (lambda (out) (displayln txt out))))

(define (respond-with-error error-code txt)
  (response/output
   #:code error-code
   #:mime-type #"text/plain; charset=utf-8"
   (lambda (out) (displayln txt out))))

(define (format-reason reason)
  (match reason
    [(cons field explanation) (format "* ~a: ~a" field explanation)]
    [_ (format "* ~a" reason)]))

(define (request-handler req)
  (match (request-method req)
    [#"GET" main-page]
    [#"POST" (post-color req)]
    [_ (respond-with-error 405 "expected GET or POST")]))

(define render-color-form
  `(form
    ((action "") (method "POST") (autocomplete "off"))
    (input ((id "red") (name "r") (type "number") (value "5") (hidden "")))
    (input ((id "green") (name "g") (type "number") (value "5") (hidden "")))
    (input ((id "blue") (name "b") (type "number") (value "5") (hidden "")))
    (input ((id "name")
            (name "name")
            (type "text")
            (minlength "2") (maxlength "34")
            (required "")
            (placeholder "Type a color name")))
    (button ((type "submit")) "submit")
    (button ((type "button") (onclick "next()")) "skip")))
    

(define main-page
  (response/xexpr
   #:preamble #"<!DOCTYPE html>"
   `(html
     (head
      (meta ((name "viewport") (content "width=device-width,initial-scale=1")))
      (link ((rel "stylesheet") (href "styles.css")))
      (script ((src "main.js") (defer "")))
      (title "What's this color?!"))
     (body
      (h1 "What's" (span ((class "colored title-span")) "this") "color?!")
      (div ((id "color")))
      (unquote render-color-form)
      (div ((class "instructions"))
        (h2 "Instructions")
        (ul
          (li "You should not use search engines or other external resources to make your decision.")
          (li "The color names can be in any language – prefer using the one you are the most fluent in!")
          (li "There are no wrong answers. Use the same word as you would in a regular conversation!")
          (li "Consider disabling dark mode browser extensions and other tools that could affect the colors.")
          (li "Creativity is allowed but not required.")))))))

(define (post-color req)
  (match (form-run color-form req)

    [(list 'passed (list r g b name) _)
     (save-colorname r g b name)
     (respond-with (format "submitted color '~a'" name))]

    [(list 'failed reasons _)
     (respond-with-error 400 (string-join (map format-reason reasons) "\n"))]

    [_
     (displayln (request-method req))
     (respond-with-error 400 "expected a POST request with form data")]))

(define (not-found-responder _req)
  (respond-with-error 404 "404 not found"))

(displayln "listening on http://localhost:8000/whatcolor (Ctrl+C to stop)")

(serve/servlet
 request-handler
 #:listen-ip "0.0.0.0"
 #:port 8000
 #:command-line? #t
 #:servlet-regexp #rx"^/whatcolor$"
 #:file-not-found-responder not-found-responder
 #:extra-files-paths (list (build-path (current-directory) "static")))

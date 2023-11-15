;;

(defun query-npm-package (package-name &key (package-version nil) (full nil))
  (let ((headers (if full
                     (make-hash-table)
                     (make-hash-table :test 'equal :initial-contents '(("Accept" . "application/vnd.npm.install-v1+json"))))))
        (url (concatenate 'string "https://registry.npmjs.com/" package-name)))
    (when package-version
      (setf url (concatenate 'string url "/" package-version)))
    (let ((request (make-instance 'http:request :uri url)))
      (unless full
        (maphash (lambda (key value)
                   (http:header-add request key value))
                 headers)))
      (with-open-url (response request)
        (http:entity-body-string response)))))

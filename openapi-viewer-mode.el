;;; openapi-viewer-mode.el -*- lexical-binding: t; -*-

;; Copyright (C) 2022  Augustin Thiercelin

;; Author: Augustin Thiercelin <nitsu.gua@outlook.fr>
;; URL: https://github.com/n1tsu/openapi-viewer-mode
;; Keywords: tools
;; Version: 0
;; Package-Requires: ((emacs "24"))

;; Permission is hereby granted, free of charge, to any person obtaining a copy
;; of this software and associated documentation files (the "Software"), to deal
;; in the Software without restriction, including without limitation the rights
;; to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
;; copies of the Software, and to permit persons to whom the Software is
;; furnished to do so, subject to the following conditions:

;; The above copyright notice and this permission notice shall be included in all
;; copies or substantial portions of the Software.

;; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
;; IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
;; FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
;; AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
;; LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
;; OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
;; SOFTWARE.

;;; Commentary:

;;; OpenAPI Viewer is a Minor Mode to preview OpenAPI specs using swagger-ui docker

(defun openapi-viewer-preview ()
  "Preview OpenAPI file in default browser."
  (interactive)

  (setq openapi-file (file-name-nondirectory buffer-file-name))
  (setq docker-dir (concat "SWAGGER_JSON=/foo/" openapi-file))
  (setq docker-volume (concat default-directory ":/foo"))

  (start-process "openapi-viewer" "*openapi-viewer*" "docker"
                 "run" "-p" "2142:8080" "-e" docker-dir "-v"
                 docker-volume "--name" "openapi-viewer"
                 "swaggerapi/swagger-ui")

  (browse-url "http://localhost:2142"))

(defun openapi-viewer-close ()
  (interactive)
  (call-process "docker" nil "*openapi-viewer*" nil
                 "stop" "openapi-viewer")
  (call-process "docker" nil "*openapi-viewer*" nil
                 "rm" "openapi-viewer")
  (delete-process "openapi-viewer"))

;;; Code:
(define-minor-mode openapi-viewer-mode
  "Minor mode for OpenAPI viewer"
  :lighter "openapi-viewer"
  :keymap (let ((map (make-sparse-keymap)))
            (define-key map (kbd "M-o p") 'openapi-viewer-preview)
            (define-key map (kbd "M-o c") 'openapi-viewer-close)
            map))

(provide 'openapi-viewer-mode)
;;; openapi-viewer-mode.el ends here

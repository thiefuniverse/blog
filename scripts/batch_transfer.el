;;;------------------------------------------------------------
;;; batch handle for blog.
;;;------------------------------------------------------------

(defun read-org-option (option)
  "Read option value of org file opened in current buffer.
e.g:
#+TITLE: this is title
will return \"this is title\" if OPTION is \"TITLE\""
  (let ((match-regexp (org-make-options-regexp `(,option))))
    (save-excursion
      (goto-char (point-min))
      (when (re-search-forward match-regexp nil t)
        (match-string-no-properties 2 nil)))))


(defun construct-one-article (date uri title)
  (concat "<h2>
    <li>
        &nbsp;<a href=\"htmls/" uri ".html\">" "
            <spe class=\"" "article-date" "\">" date "</spe>&nbsp;" title
	    "        </a>
    </li>
</h2>")
)

(defun construct-index-html (all-title-date index-html)
  "construct all titles and dates."
  (with-temp-buffer
    (dolist (one-title-date all-title-date)
      (insert  (construct-one-article (second one-title-date)
				      (first one-title-date)
				      (cdr (cdr one-title-date)))))
    (write-region (point-min) (point-max) index-html)))

(defun iterate-orgs (index-html)
  "enumerate all orgs."
  (let ((all-title-date '())
	(date-title '()))
;;; read all titles and dates to all-title-date
    (dolist (one_org (directory-files "../org"))
      (if (not (or (string-equal one_org ".")  (string-equal one_org "..")))
	  (with-temp-buffer
	    (insert-file-contents  (concat "../org/"  one_org))
	    (setq date-title (cons (read-org-option "uri") (cons (read-org-option "date")  (read-org-option "title"))))
	    (add-to-list 'all-title-date date-title))))

;;; construct new index file for articles
;;;;;; sort by date
    (setq all-title-date (sort all-title-date '(lambda (element1 element2) (string> (second element1) (second element2)))))
;;;;;; construct index
    (construct-index-html all-title-date index-html))
  (message "done iterate-orgs"))

(defun render-one (one_org)
  "render one org file."
  (setq org-html-validation-link nil)
  (let ((date-title '()))
    (save-excursion
      (with-temp-buffer
	(insert-file-contents  (concat "../org/"  one_org))
	(setq date-title (cons (read-org-option "uri") (cons (read-org-option "date")  (read-org-option "title"))))
	(org-html-export-as-html)
	(write-region (point-min) (point-max) (concat "../htmls/" (first date-title) ".html"))
	))))

(defun render-all ()
  "enumerate all orgs."
;;; read all titles and dates to all-title-date
  (let ((c-buffer (current-buffer)))
    (dolist (one_org (directory-files "../org"))
      (if (not (or (string-equal one_org ".")  (string-equal one_org "..")))
	  (render-one one_org)))
    (switch-to-buffer c-buffer)
    (kill-buffer "*Org HTML Export*"))
      (message "done successfully"))


(defun render-all-org ()
  "render all org file and update index file."
  (render-all)
  (iterate-orgs "../article_index.html"))

(defun render-one-org (org-file)
  "render one org file and update index file."
  (render-one org-file)
  (iterate-orgs "../article_index.html"))

(render-all-org)
(render-one-org "android-root.org")


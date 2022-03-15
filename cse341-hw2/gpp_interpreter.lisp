(defparameter tokenList '())
(defparameter parseTree '())

(defun gppinterpreter ()
	(setq flag 1)
	(setq inputList '())
	(loop while  (equal flag 1) 
					do (setq inputStr (read-line))
					(if (equal "EXIT" inputStr)
						 (setq flag 0) 
						 (progn 
						 	(loop for a across inputStr do (setq inputList (append inputList (list a)))) 
						 	(rec-parse inputList)
						 	(print tokenList)
						 	(setq tokenList '())
						 	(setq inputList '())
					 	)
					 ) 		 	
	)
) 

(defun rec-parse (liste)
	
	(if(not (null liste))
		(cond
		
			; for identifers and keywords
			((not (equal nil (alpha-char-p (car liste)))) 
				(check-words liste)
				(setq liste (nthcdr (1- counter) liste)))
			
			; for values(not 0)
			((and (not (equal nil (digit-char-p (car liste)))) (not (equal 0 (digit-char-p (car liste)))) )
				(check-values liste)
				(setq liste (nthcdr (1- counter) liste)))

			((equal #\; (car liste)) (check-comment liste) (setq liste (nthcdr (1- counter) liste)))	
			((equal #\+ (car liste)) (print "OP_PLUS")(terpri) (setq tokenList (append tokenList (list "OP_PLUS"))))
			((equal #\- (car liste)) (print "OP_MINUS")(terpri)(setq tokenList (append tokenList (list "OP_MINUS"))))
			((equal #\/ (car liste)) (print "OP_DIV")(terpri)(setq tokenList (append tokenList (list "OP_DIV"))))	
			((equal #\* (car liste)) (check-double-mult liste) (setq liste (nthcdr (1- counter) liste)))	
			((equal #\( (car liste)) (print "OP_OP")(terpri)(setq tokenList (append tokenList (list "OP_OP"))))	
			((equal #\) (car liste)) (print "OP_CP")(terpri)(setq tokenList (append tokenList (list "OP_CP"))))	
			((equal #\, (car liste)) (print "OP_COMMA")(terpri)(setq tokenList (append tokenList (list "OP_COMMA"))))	
			((equal #\' (car liste)) (print "OP_OC")(terpri)(setq tokenList (append tokenList (list "OP_OC"))))	
			((equal #\0 (car liste)) (print "ZERO")(terpri)(setq tokenList (append tokenList (list "ZERO"))))
			((equal #\Space (car liste)))	
			(t (print "SYNTAX ERROR")(terpri) )
			
		)
	)
	(if(not (null liste)) (rec-parse (cdr liste)))
)

(defun check-comment (liste)
	(setq counter 1)
	(setq liste (cdr liste))
	(if (equal #\; (car liste)) 
		(progn 
			(print "COMMENT") (terpri)
			(setq tokenList (append tokenList (list "COMMENT")))
			(incf counter) 
			(loop while  (not (null liste)) 
					do (setq liste (cdr liste)) (incf counter) ) )
		(progn (print "SYNTAX ERROR") (terpri))
	)
	
	counter
)

(defun check-double-mult (liste)
	(setq counter 1)
	(setq liste (cdr liste))
	(if (equal #\* (car liste)) (progn (print "OP_DBLMULT")(terpri) (setq tokenList (append tokenList (list "OP_DBLMULT"))) (incf counter)) (progn (print "OP_MULT") (terpri) (setq tokenList (append tokenList (list "OP_MULT")))))
	counter
)

(defun check-values (liste)
	(setq counter 0)
	(setq tempString "")
	(loop while  (and (not (null liste)) (not (equal nil (digit-char-p (car liste)))))
		do (setq tempString (concatenate 'string tempString (string(car liste))))
			(setq liste (cdr liste))
			(incf counter)
	)
	(print "VALUE") (terpri)
	(setq tokenList (append tokenList (list "VALUE")))
	counter
)


(defun check-words (liste)
	(setq counter 0)
	(setq tempString "")
	(loop while  (and (not (null liste)) (or (not (equal nil (alpha-char-p (car liste)))) (not (equal nil (digit-char-p (car liste))))))
		do (setq tempString (concatenate 'string tempString (string(car liste))))
			(setq liste (cdr liste))
			(incf counter)
	)
	

	(cond 
		((equal "and" tempString) (print "KW_AND")(terpri) (setq tokenList (append tokenList (list "KW_AND"))))
		((equal "or" tempString) (print "KW_OR")(terpri)(setq tokenList (append tokenList (list "KW_OR"))))
		((equal "not" tempString) (print "KW_NOT")(terpri)(setq tokenList (append tokenList (list "KW_NOT"))))
		((equal "equal" tempString) (print "KW_EQUAL")(terpri)(setq tokenList (append tokenList (list "KW_EQUAL"))))
		((equal "less" tempString) (print "KW_LESS")(terpri)(setq tokenList (append tokenList (list "KW_LESS"))))
		((equal "nil" tempString) (print "KW_NIL")(terpri)(setq tokenList (append tokenList (list "KW_NIL"))))
		((equal "list" tempString) (print "KW_LIST")(terpri)(setq tokenList (append tokenList (list "KW_LIST"))))
		((equal "append" tempString) (print "KW_APPEND")(terpri)(setq tokenList (append tokenList (list "KW_APPEND"))))
		((equal "concat" tempString) (print "KW_CONCAT")(terpri)(setq tokenList (append tokenList (list "KW_CONCAT"))))
		((equal "set" tempString) (print "KW_SET")(terpri)(setq tokenList (append tokenList (list "KW_SET"))))
		((equal "deffun" tempString) (print "KW_DEFFUN")(terpri)(setq tokenList (append tokenList (list "KW_DEFFUN"))))
		((equal "for" tempString) (print "KW_FOR")(terpri)(setq tokenList (append tokenList (list "KW_FOR"))))
		((equal "if" tempString) (print "KW_IF")(terpri)(setq tokenList (append tokenList (list "KW_IF"))))
		((equal "exit" tempString) (print "KW_EXIT")(terpri)(setq tokenList (append tokenList (list "KW_EXIT"))))
		((equal "load" tempString) (print "KW_LOAD")(terpri)(setq tokenList (append tokenList (list "KW_LOAD"))))
		((equal "disp" tempString) (print "KW_DISP")(terpri)(setq tokenList (append tokenList (list "KW_DISP"))))
		((equal "true" tempString) (print "KW_TRUE")(terpri)(setq tokenList (append tokenList (list "KW_TRUE"))))
		((equal "false" tempString) (print "KW_FALSE")(terpri)(setq tokenList (append tokenList (list "KW_FALSE"))))
		(t (print "IDENTIFIER")(setq tokenList (append tokenList (list "IDENTIFIER"))))

	)
	counter 

)

(defun concrete-syntax-analysis (tokenList)

	(setq rms tokenList)
	(setq parseStack '())
	(setq lookAhead (car tokenList))


)
(defun action (parseStack rms lookAhead tokenList )

	(cond 
		((nil parseStack) 0)
		((equal "OP_OP" lookAhead) 0)
		((equal "OP_PLUS" lookAhead) 0)
		((equal "VALUE" lookAhead) 0)
		((nil lookAhead) 1)
		
			
	)
)

(gppinterpreter)




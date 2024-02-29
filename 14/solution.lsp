(defvar *filename* "input")
(defvar *lines* nil)

(defun read-file (filename)
  (with-open-file (stream filename :direction :input :if-does-not-exist nil)
    (when stream
      (let ((contents (make-string (file-length stream))))
        (read-sequence contents stream)
        contents))))

(defun split-on-crlf (string)*
  (let ((result '())
        (start 0))
    (loop for i from 0 below (length string)
          when (and (char= (char string i) #\Return)
                    (char= (char string (1+ i)) #\Newline))
          do (progn
               (push (subseq string start i) result)
               (setq start (+ 2 i) i (1+ i))))
    (push (subseq string start) result)
    (reverse result)))

(defun rotate-90 (matrix)
  (let ((n (length matrix)))
    (let ((m (length (first matrix))))
      (loop for j from 0 below m
            collect (loop for i downfrom (- n 1) to 0
                          collect (elt (elt matrix i) j))))))

(defun move-os (vec)
  (let* ((len (length vec))
         (last-hash (position #\# vec :from-end t))
         (last-dot (position #\. vec :from-end t)))
    (loop for i from (- len 1) downto 0
       for char = (aref vec i) do
        (cond
            ((char= char #\O)
              (when (and last-dot (or (not last-hash) (> last-dot i)))
                (if (and last-hash (>= last-hash i ))
                 (setq last-dot (position #\. (subseq vec 0 last-hash) :from-end t))
                 (setq last-dot (position #\. vec :from-end t)))
                (rotatef (aref vec i) (aref vec last-dot))
                (setq last-dot (position #\. vec :from-end t))))
            ((char= char #\#)
               (setq last-dot (position #\. (subseq vec 0 i) :from-end t)
                     last-hash i))))
    vec))

(defun move-os-forward-in-list (vectors)
  (loop for vec in vectors
        collect (move-os (coerce vec 'vector))))

(defun sum-positions-of-o (lists)
  (let ((sum 0))
    (loop for list in lists
          do (loop for char across (coerce list 'vector)
                   for index from 1
                   do (when (eql char #\O)
                        (incf sum index))))
    sum))

(defun spin-cycle (lists)
  (move-os-forward-in-list (rotate-90 (move-os-forward-in-list (rotate-90 (move-os-forward-in-list (rotate-90 (move-os-forward-in-list (rotate-90 lists))))))))
)

(defun apply-n-times (func input n)
  (loop for i from 1 to n
        do (setf input (funcall func input)))
  input)

(setq *lines* (split-on-crlf (read-file *filename*)))
(format t "~%Part 1: ~a" (sum-positions-of-o (move-os-forward-in-list (rotate-90 *lines*))))

(defun cycle-until-repeat (input)
  (let* ((iteration 1)
        (current input)
        (next (spin-cycle current))
        (history (list input)))
    (loop 
      (incf iteration)
      (setf current next
            next (spin-cycle next))
      (let ((previous (position (prin1-to-string next) history :test 'equal)))
        (if previous
            (return (values iteration (- (length history) previous)))
            (push (prin1-to-string next) history))))))

(let* ((result (multiple-value-list (cycle-until-repeat *lines*)))
     (cycle (- (first result) (second result)))
     (offset (second result))
     (target (+ (mod (- 1000000000 offset) cycle) offset )))

(format t "~%Part 2: ~a" (sum-positions-of-o (rotate-90 (apply-n-times #'spin-cycle *lines* target)))))

(exit)
(script-fu-register
    "a-lorenz-resize-border"                        ;func name
    "Resize with border"                                  ;menu label
    "Resize an image to a specific size
     and apply a border whern needed"              ;description
    "Andrea Lorenzani"                             ;author
    "copyright 2016, Andrea Lorenzani"        ;copyright notice
    "June 8th, 2016"                          ;date created
    ""                     ;image type that the script works on
    SF-IMAGE "Image"       0
    SF-ADJUSTMENT "Max width" '(2000 150 4000 1 10 0 0)
    SF-ADJUSTMENT "Border" '(50 0 500 1 10 0 0)
    SF-COLOR "Border Color" "black"
  )
(script-fu-menu-register "a-lorenz-resize-border" "Lorenzani")

(define (log-with-message text value)
	(gimp-message (string-append text value))
)

(define (ratioval imgw imgh inMax)
   	(if (> imgh imgw) 
		(/ imgh inMax)
		(/ imgw inMax)
	)
)


(define (a-lorenz-resize-border image 
				inMax
				inBorder
				borderColor)
	(let*	(;parameters
			(img image)
			(log-with-message "image" "set")
			(img-w (car(gimp-image-width img)))
			(img-h (car(gimp-image-height img)))
			(ratio (ratioval img-w img-h inMax))

			(new-width (/ img-w ratio))
			(new-height (/ img-h ratio))
			(new-f-height (+ new-height (* 2 inBorder)))
			(new-f-width (+ new-width (* 2 inBorder)))

			(print new-width)
		)
		(gimp-context-push)
		(gimp-image-flatten img)
		(gimp-image-scale img new-width new-height)
		(gimp-image-resize image new-f-width new-f-height inBorder inBorder)
		(let* (
			(drawable (car (gimp-image-get-active-layer img)) ) )
			(gimp-context-set-background borderColor)
			(gimp-layer-resize-to-image-size drawable)
			;(gimp-edit-bucket-fill-full drawable 1 0 100 0 FALSE TRUE 0 0 0)
		)
;		(gimp-layer-resize drawable new-f-width new-f-height inBorder inBorder)
;		(gimp-item-transform-scale drawable 0 0 new-f-width new-f-height)
		(gimp-context-pop)
		(gimp-displays-flush)
	)
)

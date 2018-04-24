(script-fu-register
		    "Andrea-Lorenzani-Seppia-Tone"                        ;func name
		    "Advanced sepia tone"                                  ;menu label
		    "Apply sepia tone and eventually border"              ;description
		    "Andrea Lorenzani"                             ;author
		    "copyright 2012, Andrea Lorenzani"        ;copyright notice
		    "September 24th, 2012"                          ;date created
		    ""                     ;image type that the script works on
			SF-IMAGE "Image"       0
			SF-DRAWABLE "Drawable" 0
		    SF-COLOR      "Sepia color" '(162 128 101)
			SF-ADJUSTMENT "Sepia strongness" '(150 1 255 1 10 0 0)
			SF-ADJUSTMENT "% Border" '(5 0 20 0.1 0.5 1 0)
)
(script-fu-menu-register "Andrea-Lorenzani-Seppia-Tone" "<Image>/Lorenzani")
(define (Andrea-Lorenzani-Seppia-Tone 	image 
										drawable
										sepia-tone
										strongness
										border-perc)
	(let*	(;parameters
	
			;(img (car(gimp-file-load 0 filename filename))) ;we set the image
			(img image)
			(img-w (car(gimp-image-width img)))
			(img-h (car(gimp-image-height img)))
			(border (/ (* img-h border-perc) 100))
			(if (> img-w img-h) (begin  
				(let* (border (/ (* img-w border-perc) 100)))
			) )
			
			;(base-layer (car(gimp-layer-new img (car(gimp-image-width img))  (car(gimp-image-height img)) 1 "master" 0 0))) ;we set the master layer
			(base-layer (car(gimp-layer-new img img-w img-h 1 "base" 100 0)))
			(sepia-layer (car(gimp-layer-new img img-w img-h 1 "sepia" 100 13))) ;we set the sepia layer
			;(mask (gimp-channel-copy (car(gimp-channel-new-from-component img 3 "gray"))))
			(mask (car(gimp-layer-create-mask sepia-layer 0))) ; layer mask?
			;(mask (car(gimp-channel-new-from-component img 3 "Gray")))
			)
			;(print "1")
			
			; the function
			(gimp-context-push)
			
			; crea il layer base desaturato
			(gimp-edit-copy drawable)
			(gimp-image-add-layer img base-layer -1)
			(gimp-image-set-active-layer img base-layer)
			(gimp-floating-sel-anchor (car(gimp-edit-paste base-layer TRUE)) )
			(gimp-desaturate base-layer)
			;(gimp-image-merge-down img base-layer 0)
			; ora base è il layer base desaturato
			
			; Creo il sepia-layer
			(gimp-image-add-layer img sepia-layer -1)
			(gimp-context-set-foreground sepia-tone)
			(gimp-drawable-fill sepia-layer 0)
			
			(gimp-layer-add-mask sepia-layer mask)
			(gimp-edit-copy base-layer)
			(gimp-floating-sel-anchor (car(gimp-edit-paste mask TRUE)) )
			
			;(gimp-channel-combine-masks mask (car(gimp-channel-new-from-component img 3 "Gray")) 2 0 0)
			
			
			(define (points)
				(set! points (cons-array 6 'byte))
				(aset points 0 0)
				(aset points 1 0)
				(aset points 2 128)
				(aset points 3 strongness)
				(aset points 4 255)
				(aset points 5 0)
			)
			(gimp-curves-spline mask 0 6 (points))
			
			
			
			; La procedura per il sepia tone finisce qui
			
			(print border)
			
			(if (> border 0) 
				(begin
				; Qui inizia la procedura del bordo, se questo è >0
				(script-fu-fuzzy-border img base-layer '(255 255 255) border TRUE 10 FALSE 0 FALSE FALSE)
				
				(let* (
					(w-b-layer (car(gimp-image-get-active-drawable img))) 
					(border-w (car(gimp-drawable-width w-b-layer)))
					(border-h (car(gimp-drawable-height w-b-layer)))
					(copy-l (car(gimp-layer-new img border-w border-h 1 "copy of border" 100 0)))
					(black-l (car(gimp-layer-new img border-w border-h 1 "black" 100 13))) ;we set the sepia layer
			
					)
					
					; Creo il layer nero
					(gimp-image-add-layer img black-l -1)
					(gimp-context-set-foreground '(0 0 0))
					(gimp-drawable-fill black-l 0)
					; Creo copia del border
					(gimp-edit-copy w-b-layer)
					(gimp-image-add-layer img copy-l -1)
					(gimp-image-set-active-layer img copy-l)
					(gimp-floating-sel-anchor (car(gimp-edit-paste copy-l TRUE)) )
					(gimp-image-merge-down img copy-l 0)
					; Seleziono per colore
					(gimp-by-color-select (car(gimp-image-get-active-drawable img)) '(255 255 255) 15 2 TRUE FALSE 0.0 FALSE)
					(gimp-edit-bucket-fill w-b-layer 0 0 100 100 FALSE 0 0)
					(gimp-selection-none img)
					; Rimuovo il layer inutile
					(gimp-image-remove-layer img (car(gimp-image-get-active-drawable img)))
				)
				)
			)
			
			
			
			(gimp-image-merge-down img base-layer 0)
			(gimp-image-merge-down img sepia-layer 0)
			
			(gimp-context-pop)
	)
)
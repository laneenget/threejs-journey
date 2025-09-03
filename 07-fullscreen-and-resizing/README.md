
# Introduction

Our canvas currently has a fixed resolution of 800x600. We would like to have the canvas take all the available space. We need to make sure it still fits if the user resizes their window. We also need to give the user a way to experiment with the experience in fullscreen.

# Fit in the Viewport

To make the canvas fit perfectly in the viewport, instead of using fixed numbers in the sizes variable, we can use the window.innerWidth and window.innerHeight.

        // ...

        // Sizes
        const sizes = {
            width: window.innerWidth,
            height: window.innerHeight
        }

        // ...

Unfortunately, this leaves us with a white margin. The problem is that browsers all have default stylings. We can fix this in many ways, but we will keep it simple and modify the CSS.

A good first thing to do is to remove any type of margin or padding on all elements by using a wildcard *. Then we can fix the canvas on the top left using its webgl class and fix a blue outline on the canvas when drag and dropping that sometimes happens on the latest versions of Chrome.

        *
        {
            margin: 0;
            padding: 0;
        }

        .webgl
        {
            position: fixed;
            top: 0;
            left: 0;
            outline: none;
        }

To remove any type of scrolling, even on touch screens, you can add an overflow: hidden on both html and body

        html,
        body
        {
            overflow: hidden
        }

Unfortunately, if you resize at this point, the canvas won't follow. We will fix that next.

# Handle Resize

To resize the canvas, we first need to know when the window is being resized. We can do this by listening to the resize event. Once we trigger a function when the window is being resizes, we will need to update the sizes variable, update the camera aspect ratio, and update the projection matrix. Finally, we must update the renderer. All together, it will look like this.

        window.addEventListener('resize', () =>
        {
            // Update sizes
            sizes.width = window.innerWidth
            sizes.height = window.innerHeight

            // Update camera
            camera.aspect = sizes.width / sizes.height
            camera.updateProjectionMatrix()

            // Update renderer
            renderer.setSize(sizes.width, sizes.height)
        })

Now we can resize the window as we want and the canvas should cover the viewport without any scroll bar or overflow.

# Handle Pixel Ratio

If there is a blurry render and artifacts shaped like stairs on the edges (called aliasing) its because you are testing on a screen with a pixel ratio greater than 1. The pixel ratio corresponds to how many physical pixels you have on the screen for one pixel unit on the software part.

To get the screen pixel ratio, you can use the window.devicePixelRatio, and to update the pixel ratio on the renderer, you call the renderer.setPixelRatio().

We virtually never need a pixel ratio greater than 2, so we can limit the pixel ratio to 2 to avoid performance issues using the Math.min() method.

We can add this method to the resize callback too.

        window.addEventListener('resize', () =>
            {
                // Update sizes
                sizes.width = window.innerWidth
                sizes.height = window.innerHeight

                // Update camera
                camera.aspect = sizes.width / sizes.height
                camera.updateProjectionMatrix()

                // Update renderer
                renderer.setSize(sizes.width, sizes.height)
                renderer.setPixelRatio(Math.min(window.devicePixelRatio, 2))
            })

# Handle Fullscreen

First, we need to decide what action will trigger the fullscreen mode. It could be an HTML button, but instead we will use a double click.

When the double click happens, we will toggle the fullscreen. To do that, we need three things in our event.
- A way to know if it's already in fullscreen
- A method to go to fullscreen
- A method to leave fullscreen

To know if we are already in fullscreen, we can use the document.fullscreenElement. The method to request the fullscreen is associated with the element because you can choose what will be in fullscreen -- the whole page or any DOM element. We will call requestFullscreen() on the canvas. Finally, the method to leave fullscreen is available directly on the document.

        window.addEventListener('dblclick', () =>
        {
            if(!document.fullscreenElement)
            {
                canvas.requestFullscreen()
            }
            else
            {
                document.exitFullscreen()
            }
        })

We need to use prefixed versions to make the browser work for document.fullscreenElement, canvas.requestFullscreen, and document.exitFullscreen

        window.addEventListener('dblclick', () =>
        {
            const fullscreenElement = document.fullscreenElement || document.webkitFullscreenElement

            if(!fullscreenElement)
            {
                if(canvas.requestFullscreen)
                {
                    canvas.requestFullscreen()
                }
                else if(canvas.webkitRequestFullscreen)
                {
                    canvas.webkitRequestFullscreen()
                }
            }
            else
            {
                if(document.exitFullscreen)
                {
                    document.exitFullscreen()
                }
                else if(document.webkitExitFullscreen)
                {
                    document.webkitExitFullscreen()
                }
            }
        })
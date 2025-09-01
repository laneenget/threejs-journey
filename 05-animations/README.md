
# Introduction

Most of the time, you will want to animate your creations. Animations in Three.js work like stop motion. You move the objects and do a render, move the objects a little more, rerender, etc.

The screen runs at a specific frequency called a frame rate. The frame rate mostly depends on the screen, but the computer itself has limitations. Most screens run at 60 frames per second. When the computer has difficulties processing things, it will run more slowly.

We can execute a function that will move objects and do the render on each frame regardless of the frame rate using the window.requestAnimationFrame() method in native JavaScript.

# Using requestAnimationFrame

The primary purpose of requestAnimationFrame is not to run code on each frame. It will execute the function you provide on the next frame, but if this function also uses requestAnimationFrame to execute the same function on the next frame, you'll end up with your function being executed on each frame forever.

Create a function named tick and call it once. Inside tick, we will call the requestAnimationFrame to call this same function on the next frame. We can then move the renderer.render() call inside that function and increase the cube rotation.

        const tick = () =>
        {
            mesh.rotation.y += 0.01

            renderer.render(scene, camera)

            window.requestAnimationFrame(tick)
        }

        tick()

Now we have created an infinite loop allowing our cube to rotate.

# Adaptation to the Framerate Using Clock

We can adapt the animation to the framerate if we know how much time it has been since the last tick. We can instantiate a Clock variable and use the built-in methods like getElapsedTime() to return how many seconds have passed since the Clock was created. You can also use it to move things with the position property. We will combine it with Math.sin() or Math.cos() to get some kind of trig waves. These techniques can be used to animate any Object3D.

        const clock = new THREE.Clock()

        const tick = () =>
        {
            const elapsedTime = clock.getElapsedTime()

            mesh.position.x = Math.cos(elapsedTime)
            mesh.position.y = Math.sin(elapsedTime)
        }

# Introduction

We have already used a PerspectiveCamera, but there are other types of cameras as well.

## Camera

The Camera class is abstract. You should not use it directly, but you can inherit from it to have access to common properties and methods.

## ArrayCamera

The ArrayCamera is used to render your scene multiple times by using multiple cameras. Each camera will render a specific area of the canvas. You can imagine this looking like old school console multiplayer games with a split-screen.

## StereoCamera

The StereoCamera is used to render the scene through two cameras that mimic the eyes in order to create what is called a parallax effect that lures your brain into thinking there is depth.

## CubeCamera

The CubeCamera is used to get a render facing each direction (forward, backward, leftward, rightward, upward, and downward) to create a render of the surrounding. You can use it to create an environment map for reflection or a shadow map.

## OrthographicCamera

The OrthographicCamera is used to create orthographic renders of your scene without perspective. It's useful if you make an RTS game. Elements will have the same size on the screen regardless of their distance from the camera.

# PerspectiveCamera

The PerspectiveCamera class needs some parameters to be instantiated. 

The first parameter is called the field of view. It corresponds to you rcamera view's verticle amplitude angle in degrees. If you use a small angle, you'll end up with a long scope effect, and if you use a wide-angle, you'll end up with a fish eye effect because what the camera sees will be stretched or squeezed to fit the canvas.

The second parameter is called the aspect ratio. It corresponds to the width divided by the height. For now, we will use the canvas width and canvas height.

        const sizes = {
            width: 800,
            height: 600
        }

The third and fourth parameters are called near and far. They corrspond to how close and how far the camera can see. Any object or part of the object closer to the camera than the near value or further away from the camera than the far value will not show up on the render.

# OrthographicCamera

We will not use this type of camera for the rest of the lessons, but it can be useful for specific projects. It differs from the PerspectiveCamera by its lack of perspective, meaning that the objects will have the same size regardless of their distance from the camera.

The parameters you provide are different from PerspectiveCamera. Instead of the field of view, you must provide how far the camera can see in each direction (left, right, top, and bottom), and then you can provide the near and far values.

It is important to take the aspect ratio into consideration with instantiating the left and right values, or the render will vary from user to user.

# Custom Controls

We often want to control the camera with our mouse. In order to do this, we need to know the mouse coordinates. We can do this by listening to the mousemove event with addEventListener.

First, we will instantiate a PerspectiveCamera.

        const camera = new THREE.PerspectiveCamera(75, sizes.width / sizes.height, 1, 1000)

        camera.position.z = 3
        camera.lookAt(mesh.position)
        scene.add(camera)

We will create a cursor variable with default x and y properties and update those properties in the mousemove callback.

        const cursor = {
            x: 0,
            y: 0
        }

        window.addEventListener('mousemove', (event) =>
        {
            cursor.x = event.clientX / sizes.width - 0.5
            cursor.y = event.clientY / sizes.height - 0.5
        })

Dividing event.clientX by sizes.width will give use a value between 0 and 1 (if we keep the cursor above the canvas) while subtracting 0.5 will return a value between -0.5 and -0.5

You now have the mouse position stored in the cursor object variable, and you can update the position of the camera in the tick function.

        const tick = () =>
        {
            // ...

            // Update camera
            camera.position.x = cursor.x
            camera.position.y = cursor.y

            // ...
        }

It works but the axes movements seem wrong. This is due to the position.y axis being positive when going upward in Three.js but the clientY axis being positive when going downward in the webpage. You can invert the cursor.y while updating it by adding a - in front of the whole formula.

        window.addEventListener('mousemove', (event) =>
        {
            cursor.x = event.clientX / sizes.width - 0.5
            cursor.y = -(event.clientY / sizes.height - 0.5)
        })

Now we can increase the amplitude by multiplying the cursor.x and cursor.y and ask the camera to look at the mesh using the lookAt() method.

        const tick = () =>
        {
            // ...

            // Update camera
            camera.position.x = cursor.x * 5
            camera.position.y = cursor.y * 5
            camera.lookAt(mesh.position)

            // ...
        }

We can go even further by doing a full rotation of the camera around the mesh using sine and cosine functions. When combined and used with the same angle, these functions enable us to place things on a circle. To do a full rotation, the angle must have an amplitude of 2 times pi.

        const tick = () =>
        {
            // ...

            // Update camera
            camera.position.x = Math.sin(cursor.x * Math.PI * 2) * 2
            camera.position.y = cursor.y * 3
            camera.position.z = Math.cos(cursor.x * Math.PI * 2) * 2
            camera.lookAt(mesh.position)

            // ...
        }

        tick()

Three.js also has integrated classes to help do this and more.

# Built-In Controls

There are a lot of pre-made controls. We will only use one of them for the rest of the course, but here are some others.

## FlyControls

FlyControls enable moving the camera like if you were on a spaceship. You can rotate on all 3 axes, go forward and go backward.

## FirstPersonControls

FirstPersonControls is like FlyControls but with a fixed up axis. You can imagine it like a flying bird view where the bird cannot do a barrel roll. It does NOT work like in FPS games.

## PointerLockControls

PointerLockControls uses the pointer lock JavaScript API. This API hides the cursor, keeps it centered, and keeps sending the movements in the mousemove even callback. With this API you can create FPS games right inside the browser. It only handles the camera rotation when the pointer is locked. You will have to handle the camera position and game physics by yourself.

## OrbitControls

OrbitControls is similar to the controls we made in the previous lesson. You can rotate around a point with the left mouse, translate laterally using the right mouse, and zoom in or out using the wheel.

## TrackballControls

TrackballControls is just like OrbitControls but there are no limits in terms of vertical angle. You can keep rotating and do spins with the camera even if the scene gets upside down.

## TransformControls

TransformControls has nothing to do with the camera. You can use it to add a gizmo to an object to move that object.

## DragControls

DragControls also has nothing to do with the camera. You can use it to move objects on a plane facing the camera by drag and dropping them.

# OrbitControls

We will only use OrbitControls.

## Instantiating

The OrbitControls class is part of those classes that are not available by default in the THREE variable. This is where the Vite template comes in.

        import { OrbitControls } from 'three/exampls/jsm/controls/OrbitControls.js'

For it to work, you must provide the camera and the element in the page that will handle the mouse events as parameters:

        // Controls
        const controls = new OrbitControls(camera, canvas)

You can now drag and drop using both the left mouse or right mouse to move the camera, and you can scroll up or down to zoom in or out.

## Target

The camera is looking at the center of the scene by default. We can change that with the target property. This property is a Vector3, meaning that we can change its x, y, and z properties. If we want the OrbitControls to look above the cube by default, we can increase the y property and call the update method.

        controls.target.y = 2
        controls.update()

## Damping

Damping will smooth the animation by adding some kind of acceleration and friction formulas. To enable damping, switch the enableDamping property of controls to true.

In order to work properly, the controls also need to be updated on each from by calling controls.update(). We can do this in the tick function.

        // Controls
        const controls = new OrbitControls(camera, canvas)
        controls.enableDamping = true

        // ...

        const tick = () =>
        {
            // ...

            // Update controls
            controls.update()

            // ...
        }

We can use many other methods and properties to customize the controls such as rotation speed, zoom speed, zoom limit, angle limit, damping strength, and key bindings.

# When to Use Built-In Controls

If you rely too much on built-in controls, you might end up having to change how the class is working in an unexpected way. First, make sure to list all the features you need from those controls, then check if the class you're about to use can handle all of those features. If not, you'll have to do it on your own.
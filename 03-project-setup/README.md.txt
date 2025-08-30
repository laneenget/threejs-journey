
# Project Setup

## Create a Node.js Project

Create a folder that contains the website. Open the terminal that located in this folder
and run    npm init -y   . NPM will create a package.json that will contain the minimal
information needed to run a Node.js project.

## Add Dependencies

Add a dependency to a Node.js project through the terminal. Run    npm install vite    and
    npm install three    . This will generate a node_modules/ folder containing the project dependencies. This should
never be modified. The package.json has also been updated to contain an array of dependencies
with their version numbers.

## Basic website

Create the index.html file. In package.json, replace    "scripts"   with

        {
            // ...
            "scripts": {
                "dev": "vite",
                "build": "vite build"
            },
            // ...
        }

In the terminal, run    npm run dev    to run the script. Create a script.js file
and add the following to index.html at the end inside of the body.

        <!-- ... -->
        <body>
            <h1>Soon to be a Three.js website</h1>
            <script type="module" src="./script.js"></script>
        </body>
        </html>

Import Three.js in the script file.

## First Scene

We need four elements: a scene, an object, a camera, and a renderer.

### Scene

The scene is the container where you place your objects, models, particles, lights, etc.
At some point, you ask Three.js to render that scene.

        // Scene
        const scene = new THREE.Scene()

### Object

Objects can be primitive geometries, imported models, particles, lights, etc. We will start
with a simple red cube. We need to create a Mesh, which is the combination of a geometry and
a material. There are many geometries and materials (see documentation). We will make a simple
red cube.

        // Object
        const geometry = new THREE.BoxGeometry(1, 1, 1)
        const material = new THREE.MeshBasicMaterial({ color: 0xff0000 })
        const mesh = new THREE.Mesh(geometry, material)
        scene.add(mesh)

### Camera

The camera is a theoretical point of view. You can have multiple cameras and you can switch
between those cameras as you need, but usually we only need one camera. There are many different
types of cameras (see documentation), but for now we will use the PerspectiveCamera class.

We will need to provide two essential parameters. 

The field of view is how large your vision angle is. If you use a very large angle, you'll be 
able to see in every direction at once but with much distortion because the result will be drawn 
on a small rectangle. If you us a small angle, things will look zoomed in. The field of view is 
expressed in degrees and corresponds to the vertical vision angle.

The aspect ratio is the width of the canvas divided by its height. We will use temporary values
for now.

        // Sizes
        const sizes = {
            width: 800,
            height: 600
        }

        // Camera
        const camera = new THREE.PerspectiveCamera(75, sizes.width / sizes.height)
        camera.position.z = 3
        scene.add(camera)

### Renderer

We will ask the renderer to render our scene from the camera's point of view, and the result
will be drawn into a canvas. You can create the canvas yourself or let the renderer generate its
and add it to the page. For this exercise, we will add a canvas to the HTML. Replace the h1 with

        <canvas class="webgl"></canvas>

To create the renderer, we use the WebGLRenderer class with one parameter, an object containing
all the options. We need to specify the canvas property corresponding the canvas we added
to the page.

        // Canvas
        const canvas = document.querySelector('canvas.webgl')

        // ...

        // Renderer
        const renderer = new THREE.WebGLRenderer({
            canvas: canvas
        })
        renderer.setSize(sizes.width, sizes.height)

# Introduction

Three.js already support 3D text geometries with the TextGeometry class. The problem is you must specify a font, and this font must be in a particular json format called typeface.

You must have the right to use the font unless it's for personal usage.

# How to Get a Typeface Font

There are many ways of getting fonts in that format. First, you convert your font with a converter by providing a file.

You can also find fonts in the Three.js examples located in the /node_modules/three/examples/fonts/ folder. You can put them in the /static/ folder or import them directly in your JavaScript file because they are json and .json files are supported just like .js files in Vite.

        import typefaceFont from 'three/examples/fonts/helvetiker_reguler.typeface.json'

# Load the Font

To load the font, we must use a new loader class called FontLoader. This class is not available in the THREE variable, so we need to import it.

        import { FontLoader } from 'three/examples/jsm/loaders/FontLoader.js'

        // ...

        /..
        . Fonts
        ./
        const fontLoader = new FontLoader()

        fontLoader.load(
            '/fonts/helvetiker_regular.typeface.json',
            (font) =>
            {
                console.log('loaded')
            }
        )

We now have access to the font by using the font variable inside the function.

# Create the Geometry

We will use TextGeometry, and like for FontLoader, we will need to import it.

        import { TextGeometry } from 'three/examples/jsm/geometries/TextGeometry.js'

        fontLoader.load(
            '/fonts/helvetiker_regular.typeface.json',
            (font) =>
            {
                const textGeometry = new TextGeometry(
                    'Hello Three.js',
                    {
                        font: font,
                        size: 0.5,
                        depth: 0.2,
                        curveSegments: 12,
                        bevelEnabled: true,
                        bevelThickness: 0.03,
                        bevelSize: 0.02,
                        bevelOffset: 0,
                        bevelSegments: 5
                    }
                )
                const textMaterial = new THREE.MeshBasicMaterial()
                const text = new THREE.Mesh(textGeometry, textMaterial)
                scene.add(text)
            }
        )

If we enable the wireframe, we can see how the geometry is generated. Creating a text geometry is long and hard for the computer. Avoid doing it too many times and keep the geometry as low poly as possible by reducing the curveSegments and bevelSegments properties.

# Center the Text

There are several ways to center the text. One way of doing it is by using bounding. The bounding is the information associated with the geometry that tells what space is taken by that geometry. It can be a box or a sphere.

You cannot actually see those boundings, but it helps Three.js easily calculate if the object is on the screen, and if not, the object won't even be rendered. That is called frustum culling.

What we want is to use this bounding to know the size of the geometry and recenter it. By default, Three.js is using sphere bounding. What we want is a box bounding. We can do this by calling computeBoundingBox() on the geometry.

        textGeometry.computeBoundingBox()

The result is an object called Box3 that has a min property and a max property. The min property isn't at 0 as we could have expected. This is due to the bevelThickness and bevelSize, but we can ignore this for now.

Instead of moving the mesh, we are going to move the whole geometry. This way, the mesh will still be in the center of the scene, but the text geometry will also be centered inside the mesh.

To do this, we can use the translate method on our geometry. The text should be centered, but if you want to be very precise, you should also subtract the bevelSize which is 0.02.

        textGeometry.translate(
            - (textGeometry.boundingBox.max.x - 0.2) * 0.5
            - (textGeometry.boundingBox.max.y - 0.2) * 0.5
            - (textGeometry.boundingBox.max.z - 0.2) * 0.5
        )

We can also just call the center() method on the geometry.

        textGeometry.center()

# Add a Matcap Material

We are going to use a MeshMatcapMaterial because it looks good and has great performance.

We are going to use the matcaps located in the /static/textures/matcaps/ folder for this project. If you are using matcaps from an outside source, make sure you have the right to use it. A 256x256 resolution should be enough.

        const matcapTexture = textureLoader.load('/textures/matcaps/1.png')

Textures used as map and matcap are supposed to be encoded in sRGB and we need to inform Three.js of this by setting their colorSpace to THREE.SRGBColorSpace.

        const matcapTexture = textureLoader.load('/textures/matcaps/1.png')
        matcapTexture.colorSpace = THREE.SRGBColorSpace

We can now replace our MeshBasicMaterial with the MeshMatcapMaterial and use our matcapTexture variable with the matcap property.

        const textMaterial = new THREE.MeshMatcapMaterial({ matcap: matcapTexture })

# Add Objects

Let's add objects floating around. We can do this by creating one donut inside a loop function. In the success function, right after the text part, add the loop function and create a TorusGeometry with the same material as for the text and the Mesh. This will give us 100 donuts all in the same place, but let's add some randomness for their positions.

        for(let i = 0; i < 100; i++)
        {
            const donutGeometry = new THREE.TorusGeometry(0.3, 0.2, 20, 45)
            const donutMaterial = new THREE.MeshMatcapMaterial({ matcap: matcapTexture })
            const donut = new THREE.Mesh(donutGeometry, donutMaterial)
            scene.add(donut)
        }

        donut.position.x = (Math.random() - 0.5) * 10
        donut.position.y = (Math.random() - 0.5) * 10
        donut.position.z = (Math.random() - 0.5) * 10

We will also add some randomness to the rotation. We don't need to rotate on all three axes, and because the donut is symmetric, half a revolution is enough.

        donut.rotation.x = Math.random() * Math.PI
        donut.rotation.y = Math.random() * Math.PI

Finally, we can add randomness to the scale, but we will need to use the same value for all 3 axes.

        const scale = Math.random()
        donut.scale.set(scale, scale, scale)

# Optimize

Our code isn't very optimized. Let's move the donutGeometry and donutMaterial out of the loop.

        const donutGeometry = new THREE.TorusGeometry(0.3, 0.2, 20, 45)
        const donutMaterial = new THREE.MeshMatcapMaterial({ matcap: matcapTexture })

        for(let i = 0; i < 100; i++)
        {
            // ...
        }

Let's also remove the donutMaterial, rename the textMaterial, and use it for both the text and the donut.

        const material = new THREE.MeshMatcapMaterial({ matcap: matcapTexture })

        // ...

        const text = new THREE.Mesh(textGeometry, material)

        // ...

        for(let i = 0; i < 100; i++)
        {
            const donut = new THREE.Mesh(donutGeometry, material)

            // ...
        }

We can go even further, but we will learn more in the lesson on optimizations.
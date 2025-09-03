
# Introduction

We will discover various other geometries besides the BoxGeometry we have used in previous lessons. First, we need to understand what a geometry really is.

# What Is a Geometry?

In Three.js, geometries are composed of vertices (point coordinates in 3D space) and faces (triangles that join those vertices to create a surface).

We use geometries to create meshes, but you can also use geometries to form particles. Each vertex will correspond to a particle.

We can store more data than the position in the vertices, like the UV coordinates or the normals, but we will learn more about those later.

# The Different Built-In Geometries

All the built-in geometries inherit from the BufferGeometry class. This class has many built in methods like translate(), rotateX(), normalize(), etc.

The different geometries include:
- BoxGeometry: to create a box
- PlaneGeometry: to create a rectangle plane
- CircleGeometry: to create a disc or a portion of a disc (like a pie chart)
- ConeGeometry: to create a cone or a portion of a cone
- CylinderGeometry: to create a cylinder
- RingGeometry: to create a flat ring or portion of a flat circle
- TorusGeometry: to create a ring that has a thickness (like a donut) or a portion of a ring
- TorusKnotGeometry: to create some sort of knot geometry
- DodecahedronGeometry: to create a 12-faced sphere
- OctahedronGeometry: to create an 8-faced sphere
- TetrahedronGeometry: to create a 4-faced sphere
- IcosahedronGeometry: to create a sphere composed of triangles that have roughly the same size
- SphereGeometry: to create the most popular type of sphere where faces look like quads
- ShapeGeometry: to create a shape based on a path
- TubeGeometry: to create a tube following a path
- ExtrudeGeometry: to create an extrusion based on a path (you can add and control the bevel)
- LatheGeometry: to create a vase or portion of a vase (like a revolution)
- TextGeometry: to create 3D text

You can also create your own geometry in JavaScript, or you can make it in a 3D software like Blender and import it into the project.

# Box Example

We already made a cube, but we haven't looked much at the parameters for the BoxGeometry.
- width: the size on the x-axis
- height: the size on the y-axis
- depth: the size on the z-axis
- widthSegments: how many subdivisions in the x-axis
- heightSegments: how many subdivisions in the y-axis
- depthSegments: how many subdivisions in the z-axis

Subdivisions correspond to how many triangles should compose the face. By default it's 1, meaning there will only be 2 triangles per face. If you set the subdivision to 2, you'll end up with 8 triangles per face. To see these triangles, we can add wireframe: true to our material.

        const geometry = new THREE.BoxGeometry(1, 1, 1, 2, 2, 2)
        const material = new THREE.MeshBasicMaterial({ color: 0xff0000, wireframe: true })

The more subdivisions we add, the less we can distinguish the faces. However, too many vertices and faces will affect performance.

# Creating Your Own Buffer Geometry

Sometimes, we need to create our own geometries. If the geometry is very complex or with a precise shape, its better to create it in a 3D software, but if the geometry isn't too complex, we can build it ourself by using BufferGeometry.

To add vertices to a BufferGeometry you must start with a Float32Array. These are native JavaScript typed arrays. You can only store floats inside, and the length of the array is fixed. You can specify the length of the array and fill in the values later, or pass an array on instantiation.

        const positionsArray = new Float32Array([
            0, 0, 0,
            0, 1, 0,
            1, 0, 0
        ])

The coordinates of the vertices are specified linearly. The array is a one-dimensional array where you specify the x, y, and z of the first vertex, followed by the x, y, and z of the second vertex, and so on.

Before you can send that array to the BufferGeometry, you have to transform it into a BufferAttribute. The first parameter corresponds to your typed array and the second parameter corresponds to how much values make one vertex attribute. To read this array, we have to go 3 by 3 because a vertex position is composed of 3 values. Then we can add this attribute to our BufferGeometry using the setAttribute() method. The first parameter is the name of the attribute and the second parameter is the value.

        const positionsAttribute = new THREE.BufferAttribute(positionsArray, 3)
        geometry.setAttribute('position', positionsAttribute)

We chose position as the name because Three.js internal shaders will look for that value to position the vertices.

We can also create a bunch of random triangles.

        // Create an empty BufferGeometry
        const geometry = new THREE.BufferGeometry()

        // Create 50 triangles (450 values)
        const count = 50
        const positionsArray = new Float32Array(count * 3 * 3)
        for(let i = 0; i < count * 3 * 3; i++)
        {
            positionsArray[i] = (Math.random() - 0.5) * 4
        }

        // Create the attribute and name it 'position'
        const positionsAttribute = new THREE.BufferAttribute(positionsArray, 3)
        geometry.setAttribiute('position', positionsAttribute)

# Index

One thing with BufferGeometry is that you can mutualize vertices using the index property. Consider a cube. Multiple faces can use some vertices like the ones in the corners. And if you look closely, every vertex can be used by various neighbor triangles. That will result in a smaller attribute array and performance improvement.
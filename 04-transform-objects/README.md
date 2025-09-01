
# Introduction

There are 4 properties to transform objects in a scene.
- position (to move the object)
- scale (to resize the object)
- rotation (to rotate the object)
- quaternion (also to rotate the object)

All classes that inherit from the Object3D class posess these properties. These properties are compiled in matrices.

# Move Objects

The position possesses 3 essential properties: x, y, and z. These are the axes to position something in a 3D space.

The direction of each axis is arbitrary and can vary according to the environment, but typically we consider that y is going upward, z is going backward, and x is going to the right.

The position property is an instance of the Vector3 class. The class has many useful methods.

        mesh.position.length()
        mesh.position.distanceTo(camera.position)
        mesh.position.normalize()
        mesh.position.set(0.7, -0.6, 1)

## AxesHelper

It can be challenging to visualize where each axis oriented, especially when we start to move the camera. A solution to this is to use the AxesHelper, which will display 3 lines corresponding to the x, y, and z axes, each one starting at the center of the scene and going in the corresponding direction. You can specify the length of the lines as the only parameter.

        const axesHelper = new THREE.AxesHelper()
        scene.add(axesHelper)

# Scale Objects

scale is also a Vector3. By default, x, y, and z are equal to 1, meaning the object has no scaling applied. If you put 0.5 as a value, the object will be half of its size on the axis. If you put 2 as a value, it will be twice its original size on the axis.

        mesh.scale.x = 2
        mesh.scale.y = 0.25
        mesh.scale.z = 0.5

Because its a Vector3, we can use all the methods used for positions.

# Rotate Objects

There are two ways of handling a rotation: the rotation and quaternion properties.

## Rotation

The rotation property also has x, y, and z properties, but instead of a Vector3, it is a Euler. When you change the x, y, and z properties of a Euler, you can imagine putting a stick through your object's center in the axis' direction and rotating that object on that stick.
- If you spin on the y axis, it will move like a carousel.
- If you spin on the x axis, it will be like rotating the wheels of a car.
- If you spin on the z axis, it will be like rotating the propellers in front of an aircraft.

The value of these axes is expressed in radians. If you want to achieve half a rotation, in native JavaScript you can use Math.PI

        mesh.rotation.x = Math.PI * 0.25
        mesh.rotation.y = Math.PI * 0.25

Combining rotations can end up with strange results. While you rotate the x axis, you also change the other axes' orientation. Since the rotation applies in the order of x, y, z, it can result in weird behaviors. We can change this order by using the reorder method.

        object.rotation.reorder('YXZ')

Since the order problem can cause issues, most engines and 3D softwares use a quaternion instead of the Euler rotation.

## Quaternion

The quaternion property expresses a rotation in a more mathematical way, which solves the order problem. We will not cover how quaternions work right now, but keep in mind that the quaternion updates when you change the rotation.

# Look At This!

Object3D instances have a method named lookAt() which lets you ask an object to look at something. The object will automatically rotate its -z axis toward the target provided. You can use it to rotate the camera toward an object.

        camera.lookAt(new THREE.Vector3(0, -1, 0))
        camera.lookAt(meshPosition)

# Scene Graph

At some point, you may want to group things. If we are building a house with walls, doors, windows, and a roof and realize later we need to make it bigger or move its position, we can use the Group class to contain the seperate objects and scale the container.

Because the Group class inherits from the Object3D class, it has access to the properties mentioned previously.

        const group = new THREE.Group()
        group.scale.y = 2
        group.rotation.y = 0.2
        scene.add(group)

        const cube1 = new THREE.Mesh(
            new THREE.BoxGeometry(1, 1, 1),
            new THREE.MeshBasicMaterial({ color: 0xff0000 })
        )
        cube1.position.x = -1.5
        group.add(cube1)

        const cube2 = new THREE.Mesh(
            new THREE.BoxGeometry(1, 1, 1),
            new THREE.MeshBasicMaterial({ color: 0xff0000 })
        )
        cube2.position.x = 0
        group.add(cube2)

        const cube3 = new THREE.Mesh(
            new THREE.BoxGeometry(1, 1, 1),
            new THREE.MeshBasicMaterial({ color: 0xff0000 })
        )
        cube3.position.x = 1.5
        group.add(cube1)
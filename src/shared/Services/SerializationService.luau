--!strict
--@author Álvaro Fernández Barrero
--@date 2025/12/23

-------------------------------------
-- Types
-------------------------------------

-- All possible kind of numbers in computer science, with different amount if bytes needed to represent them
export type numeric = "byte" | "ubyte" | "short" | "ushort" | "int" | "uint" | "float" | "double"

-------------------------------------
-- Variables
-------------------------------------

local SerializationService = {}

-------------------------------------
-- Methods
-------------------------------------

--[[
    Serializes the given number. According to the given type of number, it will need more or less space in memory to be represented. It is used as follows:
    ```luau
    SerializationService.serializeNumber(120, "byte") -- 8-bit signed number
    SerializationService.serializeNumber(255, "ubyte") -- 8-bit unsigned number
    ```
    * byte (signed 8-bit number)
    * ubyte (unsigned 8-bit number)
    * short (signed 16-bit number)
    * ushort (unsigned 16-bit number)
    * int (signed 32-bit number)
    * uint (unsigned 32-bit number)
    * float (signed 32-floating-comma-bit number)
    * double (signed 64-floating-comma-bit number)

    @param x Number to serialize
    @param type The kind of number to serialize. Useful to check how many bytes it needs:
    @return The given number serialized as a buffer
    @error Incorrect type of number
]]
function SerializationService.serializeNumber(x : number, type : numeric) : buffer
    if type == "byte" then
        local numberBuffer = buffer.create(1)
        buffer.writei8(numberBuffer, 0, x)

        return numberBuffer
    end

    if type == "ubyte" then
        local numberBuffer = buffer.create(1)
        buffer.writeu8(numberBuffer, 0, x)

        return numberBuffer
    end

    if type == "short" then
        local numberBuffer = buffer.create(2)
        buffer.writei16(numberBuffer, 0, x)

        return numberBuffer
    end

    if type == "ushort" then
        local numberBuffer = buffer.create(2)
        buffer.writeu16(numberBuffer, 0, x)

        return numberBuffer
    end

    if type == "int" then
        local numberBuffer = buffer.create(4)
        buffer.writei32(numberBuffer, 0, x)

        return numberBuffer
    end

    if type == "uint" then
        local numberBuffer = buffer.create(4)
        buffer.writeu32(numberBuffer, 0, x)

        return numberBuffer
    end

    if type == "float" then
        local numberBuffer = buffer.create(4)
        buffer.writef32(numberBuffer, 0, x)

        return numberBuffer
    end

    if type == "double" then
        local numberBuffer = buffer.create(8)
        buffer.writef64(numberBuffer, 0, x)

        return numberBuffer
    end

    warn("The type does not correspond to any of the available numeric types. Check and correct it to optimize the space in memory it needs")
    return buffer.create(0)
end


--[[
    Serializes the given Vector3, it will only use 12 bytes in memory
    @param vector Vector to serialize
    @return The given vector serialized as a buffer
]]
function SerializationService.serializeVector3(vector : Vector3) : buffer
    local vectorBuffer = buffer.create(12)

    buffer.writef32(vectorBuffer, 0, vector.X)
    buffer.writef32(vectorBuffer, 1, vector.Y)
    buffer.writef32(vectorBuffer, 2, vector.Z)

    return vectorBuffer
end


--[[
    Deserializes the given buffer which must store a Vector3
    @param vector Buffer to deserialize
    @return Vector3 stored in the given buffer
]]
function SerializationService.deserializeVector3(vector : buffer) : Vector3
    return Vector3.new(
        buffer.readf32(vector, 0),
        buffer.readf32(vector, 1),
        buffer.readf32(vector, 2)
    )
end


--[[
    Serializes the given Vector3, it will only use 12 bytes in memory
    @param vector Vector to serialize
    @return The given vector serialized as a buffer
]]
function SerializationService.serializeVector3int16(vector : Vector3int16) : buffer
    local vectorBuffer = buffer.create(6)

    buffer.writei16(vectorBuffer, 0, vector.X)
    buffer.writei16(vectorBuffer, 1, vector.Y)
    buffer.writei16(vectorBuffer, 2, vector.Z)

    return vectorBuffer
end


--[[
    Deserializes the given buffer which must store a Vector3
    @param vector Buffer to deserialize
    @return Vector3 stored in the given buffer
]]
function SerializationService.deserializeVector3int16(vector : buffer) : Vector3int16
    return Vector3int16.new(
        buffer.readf32(vector, 0),
        buffer.readf32(vector, 1),
        buffer.readf32(vector, 2)
    )
end


--[[
    Serializes the given Color3, it will only use 3 bytes in memory
    @param color Color to serialize
    @return Serialized color as a buffer
]]
function SerializationService.serializeColor3(color : Color3) : buffer
    local colorBuffer = buffer.create(3)

    buffer.writeu8(colorBuffer, 0, math.floor(color.R * 255))
    buffer.writeu8(colorBuffer, 1, math.floor(color.G * 255))
    buffer.writeu8(colorBuffer, 2, math.floor(color.B * 255))

    return colorBuffer
end


--[[
    Deserializes the given buffer which must store a color
    @param color Buffer to deserialize
    @return Color stored in the given buffer
]]
function SerializationService.deserializeColor3(color : buffer) : Color3
    return Color3.fromRGB(
        buffer.readu8(color, 0),
        buffer.readu8(color, 1),
        buffer.readu8(color, 2)
    )
end


--[[
    Serializes any kind of data. If it is a number, it will assume a float (signed floating comma with 32 bits)
    @param data Data to serialize
    @return Serialized data as a buffer
    @error The given data cannot be serialized
]]
function SerializationService.serializeAny(data : any) : buffer?
    if type(data) == "number" then
        return SerializationService.serializeNumber(data, "float")
    end

    if typeof(data) == "Vector3" then
        return SerializationService.serializeVector3(data)
    end

    if typeof(data) == "Vector3int16" then
        return SerializationService.serializeVector3int16(data)
    end

    if typeof(data) == "Color3" then
        return SerializationService.serializeColor3(data)
    end

    error("The given data cannot be serialized!")
    return nil
end


return SerializationService
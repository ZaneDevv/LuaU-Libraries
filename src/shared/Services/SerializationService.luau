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
    Serializes the given number as a byte, which is a 8-bit signed number
    @param byte The number to serialize
    @return The number serializated as a buffer
]]
function SerializationService.serializeByte(byte : number) : buffer
    local byteBuffer = buffer.create(1)
    buffer.writei8(byteBuffer, 0, byte)

    return byteBuffer
end


--[[
    Deserializes the given buffer which must store a byte
    @param byte Buffer to deserialize
    @return Byte stored in the given buffer
]]
function SerializationService.deserializeByte(byte : buffer) : number
    assert(buffer.len(byte) == 1, "A 1-byte buffer is required")

    return buffer.readi8(byte, 0)
end


--[[
    Serializes the given number as an ubyte, which is a 8-bit unsigned number
    @param ubyte The number to serialize
    @return The number serializated as a buffer
]]
function SerializationService.serializeUbyte(ubyte : number) : buffer
    local ubyteBuffer = buffer.create(1)
    buffer.writeu8(ubyteBuffer, 0, ubyte)

    return ubyteBuffer
end


--[[
    Deserializes the given buffer which must store an ubyte
    @param ubyte Buffer to deserialize
    @return Ubyte stored in the given buffer
]]
function SerializationService.deserializeUbyte(ubyte : buffer) : number
    assert(buffer.len(ubyte) == 1, "A 1-byte buffer is required")

    return buffer.readu8(ubyte, 0)
end



--[[
    Serializes the given number as a short, which is a 16-bit signed number
    @param short The number to serialize
    @return The number serializated as a buffer
]]
function SerializationService.serializeShort(short : number) : buffer
    local shortBuffer = buffer.create(2)
    buffer.writei16(shortBuffer, 0, short)

    return shortBuffer
end


--[[
    Deserializes the given buffer which must store a short
    @param short Buffer to deserialize
    @return Short stored in the given buffer
]]
function SerializationService.deserializeShort(short : buffer) : number
    assert(buffer.len(short) == 2, "A 2-byte buffer is required")

    return buffer.readi16(short, 0)
end


--[[
    Serializes the given number as an ushort, which is a 16-bit unsigned number
    @param ushort The number to serialize
    @return The number serializated as a buffer
]]
function SerializationService.serializeUshort(ushort : number) : buffer
    local ushortBuffer = buffer.create(2)
    buffer.writeu16(ushortBuffer, 0, ushort)

    return ushortBuffer
end


--[[
    Deserializes the given buffer which must store an ushort
    @param ushort Buffer to deserialize
    @return Ushort stored in the given buffer
]]
function SerializationService.deserializeUshort(ushort : buffer) : number
    assert(buffer.len(ushort) == 2, "A 2-byte buffer is required")

    return buffer.readu16(ushort, 0)
end


--[[
    Serializes the given number as an int, which is a 32-bit signed number
    @param int The number to serialize
    @return The number serializated as a buffer
]]
function SerializationService.serializeInt(int : number) : buffer
    local intBuffer = buffer.create(4)
    buffer.writei32(intBuffer, 0, int)

    return intBuffer
end


--[[
    Deserializes the given buffer which must store an int
    @param int Buffer to deserialize
    @return Int stored in the given buffer
]]
function SerializationService.deserializeInt(int : buffer) : number
    assert(buffer.len(int) == 4, "A 4-byte buffer is required")

    return buffer.readi32(int, 0)
end


--[[
    Serializes the given number as an uint, which is a 32-bit unsigned number
    @param uint The number to serialize
    @return The number serializated as a buffer
]]
function SerializationService.serializeUint(uint : number) : buffer
    local uintBuffer = buffer.create(4)
    buffer.writeu32(uintBuffer, 0, uint)

    return uintBuffer
end


--[[
    Deserializes the given buffer which must store an uint
    @param uint Buffer to deserialize
    @return Uint stored in the given buffer
]]
function SerializationService.deserializeUint(uint : buffer) : number
    assert(buffer.len(uint) == 4, "A 4-byte buffer is required")

    return buffer.readu32(uint, 0)
end


--[[
    Serializes the given number as a float, which is a 32-bit floating point number
    @param float The number to serialize
    @return The number serializated as a buffer
]]
function SerializationService.serializeFloat(float : number) : buffer
    local floatBuffer = buffer.create(4)
    buffer.writef32(floatBuffer, 0, float)

    return floatBuffer
end


--[[
    Deserializes the given buffer which must store a float
    @param float Buffer to deserialize
    @return Float stored in the given buffer
]]
function SerializationService.deserializeFloat(float : buffer) : number
    assert(buffer.len(float) == 4, "A 4-byte buffer is required")

    return buffer.readf32(float, 0)
end


--[[
    Serializes the given number as a double, which is a 64-bit floating point number
    @param double The number to serialize
    @return The number serializated as a buffer
]]
function SerializationService.serializeDouble(double : number) : buffer
    local doubleBuffer = buffer.create(8)
    buffer.writef64(doubleBuffer, 0, double)

    return doubleBuffer
end


--[[
    Deserializes the given buffer which must store a double
    @param double Buffer to deserialize
    @return Double stored in the given buffer
]]
function SerializationService.deserializeDouble(double : buffer) : number
    assert(buffer.len(double) == 8, "An 8-byte buffer is required")

    return buffer.readf64(double, 0)
end


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
        return SerializationService.serializeByte(x)
    elseif type == "ubyte" then
        return SerializationService.serializeUbyte(x)
    elseif type == "short" then
        return SerializationService.serializeShort(x)
    elseif type == "ushort" then
        return SerializationService.serializeUshort(x)
    elseif type == "int" then
        return SerializationService.serializeInt(x)
    elseif type == "uint" then
        return SerializationService.serializeUint(x)
    elseif type == "float" then
        return SerializationService.serializeFloat(x)
    elseif type == "double" then
        return SerializationService.serializeDouble(x)
    end


    warn("The type does not correspond to any of the available numeric types. Check and correct it to optimize the space in memory it needs")
    return buffer.create(0)
end



--[[
    Deserializes the given buffer. According to the given type of number, it will read the appropriate amount of bytes from memory.
    
    * byte (signed 8-bit number)
    * ubyte (unsigned 8-bit number)
    * short (signed 16-bit number)
    * ushort (unsigned 16-bit number)
    * int (signed 32-bit number)
    * uint (unsigned 32-bit number)
    * float (signed 32-floating-comma-bit number)
    * double (signed 64-floating-comma-bit number)

    @param x Buffer to deserialize
    @param type The kind of number stored in the buffer
    @return The number stored in the given buffer
    @error Incorrect type of number
]]
function SerializationService.deserializeNumber(x : buffer, type : numeric) : number
    if type == "byte" then
        return SerializationService.deserializeByte(x)
    elseif type == "ubyte" then
        return SerializationService.deserializeUbyte(x)
    elseif type == "short" then
        return SerializationService.deserializeShort(x)
    elseif type == "ushort" then
        return SerializationService.deserializeUshort(x)
    elseif type == "int" then
        return SerializationService.deserializeInt(x)
    elseif type == "uint" then
        return SerializationService.deserializeUint(x)
    elseif type == "float" then
        return SerializationService.deserializeFloat(x)
    elseif type == "double" then
        return SerializationService.deserializeDouble(x)
    end

    warn("The type does not correspond to any of the available numeric types. Check and correct it")
    return 0
end


--[[
    Serializes the given Vector2, it will only use 8 bytes in memory
    @param vector Vector to serialize
    @return The given vector serialized as a buffer
    @error The given buffer has no 8 bytes, which means it is not a Vector2
]]
function SerializationService.serializeVector2(vector : Vector2) : buffer
    local vectorBuffer = buffer.create(8)

    buffer.writef32(vectorBuffer, 0, vector.X)
    buffer.writef32(vectorBuffer, 4, vector.Y)

    return vectorBuffer
end


--[[
    Deserializes the given buffer which must store a Vector2
    @param vector Buffer to deserialize
    @return Vector2 stored in the given buffer
    @error he given buffer has no 8 bytes, which means it is not a Vector2
]]
function SerializationService.deserializeVector2(vector : buffer) : Vector2
    assert(buffer.len(vector) == 8, "A 8-byte buffer is required")

    return Vector2.new(
        buffer.readf32(vector, 0),
        buffer.readf32(vector, 4)
    )
end


--[[
    Serializes the given Vector3, it will only use 12 bytes in memory
    @param vector Vector to serialize
    @return The given vector serialized as a buffer
    @error The given buffer has no 12 bytes, which means it is not a Vector3
]]
function SerializationService.serializeVector3(vector : Vector3) : buffer
    local vectorBuffer = buffer.create(12)

    buffer.writef32(vectorBuffer, 0, vector.X)
    buffer.writef32(vectorBuffer, 4, vector.Y)
    buffer.writef32(vectorBuffer, 8, vector.Z)

    return vectorBuffer
end


--[[
    Deserializes the given buffer which must store a Vector3
    @param vector Buffer to deserialize
    @return Vector3 stored in the given buffer
    @error he given buffer has no 12 bytes, which means it is not a Vector3
]]
function SerializationService.deserializeVector3(vector : buffer) : Vector3
    assert(buffer.len(vector) == 12, "A 12-byte buffer is required")

    return Vector3.new(
        buffer.readf32(vector, 0),
        buffer.readf32(vector, 4),
        buffer.readf32(vector, 8)
    )
end


--[[
    Serializes the given Vector3, it will only use 6 bytes in memory
    @param vector Vector to serialize
    @return The given vector serialized as a buffer
]]
function SerializationService.serializeVector3int16(vector : Vector3int16) : buffer
    local vectorBuffer = buffer.create(6)

    buffer.writei16(vectorBuffer, 0, vector.X)
    buffer.writei16(vectorBuffer, 2, vector.Y)
    buffer.writei16(vectorBuffer, 4, vector.Z)

    return vectorBuffer
end


--[[
    Deserializes the given buffer which must store a Vector3
    @param vector Buffer to deserialize
    @return Vector3 stored in the given buffer
    @error The given buffer has no 6 bytes, which means it is not a Vector3int16
]]
function SerializationService.deserializeVector3int16(vector : buffer) : Vector3int16
    assert(buffer.len(vector) == 6, "A 6-byte buffer is required")

    return Vector3int16.new(
        buffer.readi16(vector, 0),
        buffer.readi16(vector, 2),
        buffer.readi16(vector, 4)
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
    @error The given buffer has no 3 bytes, which means it is not a Color3
]]
function SerializationService.deserializeColor3(color : buffer) : Color3
    assert(buffer.len(color) == 3, "A 3-byte buffer is required")

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
        return SerializationService.serializeFloat(data)
    end

    if typeof(data) == "Vector2" then
        return SerializationService.serializeVector2(data)
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
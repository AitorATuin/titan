local types = require "titan-compiler.types"

describe("Titan types", function()

    it("pretty-prints types", function()
        assert.same("{ integer }", types.tostring(types.Array(types.Integer)))
    end)

    it("checks if a type is garbage collected", function()
        assert.truthy(types.is_gc(types.String))
        assert.truthy(types.is_gc(types.Array(types.Integer)))
        assert.falsy(types.is_gc(types.Function({}, {})))
    end)

    it("checks if a type matches a tag", function()
        assert.truthy(types.has_tag(types.String, "String"))
        assert.truthy(types.has_tag(types.Integer, "Integer"))
    end)

    it("compares identical functions", function()
        local f1 = types.Function({types.String, types.Integer}, {types.Boolean})
        local f2 = types.Function({types.String, types.Integer}, {types.Boolean})
        assert.truthy(types.equals(f1, f2))
    end)

    it("compares functions with different arguments", function()
        local f1 = types.Function({types.String, types.Boolean}, {types.Boolean})
        local f2 = types.Function({types.Integer, types.Integer}, {types.Boolean})
        assert.falsy(types.equals(f1, f2))
    end)

    it("compares functions with different returns", function()
        local f1 = types.Function({types.String, types.Integer}, {types.Boolean})
        local f2 = types.Function({types.String, types.Integer}, {types.Integer})
        assert.falsy(types.equals(f1, f2))
    end)

    it("compares functions of different input arity", function()
        local s = types.String
        local f1 = types.Function({}, {s})
        local f2 = types.Function({s}, {s})
        local f3 = types.Function({s, s}, {s})
        assert.falsy(types.equals(f1, f2))
        assert.falsy(types.equals(f2, f1))
        assert.falsy(types.equals(f2, f3))
        assert.falsy(types.equals(f3, f2))
        assert.falsy(types.equals(f1, f3))
        assert.falsy(types.equals(f3, f1))
    end)

    it("compares functions of different output arity", function()
        local s = types.String
        local f1 = types.Function({s}, {})
        local f2 = types.Function({s}, {s})
        local f3 = types.Function({s}, {s, s})
        assert.falsy(types.equals(f1, f2))
        assert.falsy(types.equals(f2, f1))
        assert.falsy(types.equals(f2, f3))
        assert.falsy(types.equals(f3, f2))
        assert.falsy(types.equals(f1, f3))
        assert.falsy(types.equals(f3, f1))
    end)

end)

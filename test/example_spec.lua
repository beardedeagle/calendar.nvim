-- test/example_spec.lua
-- Example test file demonstrating the test framework usage

local lu = require('luaunit')

TestConfig = {}

function TestConfig:test_default_config()
  local config = require('calendar.config')
  local cfg = config.get()
  lu.assertNotNil(cfg)
  lu.assertEquals(cfg.mark_icon, '*')
  lu.assertEquals(cfg.locale, 'en-US')
  lu.assertTrue(cfg.show_adjacent_days)
end

function TestConfig:test_custom_keymap()
  local config = require('calendar.config')
  local cfg = config.get()
  lu.assertEquals(cfg.keymap.next_month, 'L')
  lu.assertEquals(cfg.keymap.previous_month, 'H')
  lu.assertEquals(cfg.keymap.close, 'q')
end

TestModel = {}

function TestModel:test_month_info_january_2025()
  local model = require('calendar.model')
  local info = model.month_info(2025, 1)
  lu.assertEquals(info.days, 31)
  -- January 1, 2025 is a Wednesday (3 in %w format, 0=Sunday)
  lu.assertEquals(info.first_wday, 3)
end

function TestModel:test_month_info_february_2024_leap()
  local model = require('calendar.model')
  local info = model.month_info(2024, 2)
  -- 2024 is a leap year, February has 29 days
  lu.assertEquals(info.days, 29)
end

function TestModel:test_month_info_february_2025_nonleap()
  local model = require('calendar.model')
  local info = model.month_info(2025, 2)
  lu.assertEquals(info.days, 28)
end

function TestModel:test_build_month_grid()
  local model = require('calendar.model')
  local grid = model.build_month_grid(2025, 1)
  lu.assertNotNil(grid)
  lu.assertEquals(#grid, 6)
  lu.assertEquals(grid.days, 31)
end

TestExtensions = {}

function TestExtensions:test_mark_and_has_marks()
  local ext = require('calendar.extensions')
  ext.mark(2025, 1, 15)
  lu.assertTrue(ext.has_marks(2025, 1, 15))
  lu.assertNil(ext.has_marks(2025, 1, 16))
end

function TestExtensions:test_register()
  local ext = require('calendar.extensions')
  local mock_ext = {
    get = function()
      return {}
    end,
    actions = {},
  }
  ext.register('mock', mock_ext)
  -- Should not error
  lu.assertTrue(true)
end

TestSetup = {}

function TestSetup:test_setup_returns_no_error()
  local calendar = require('calendar')
  -- setup was already called in minimal_init.lua, call again with new opts
  calendar.setup({ mark_icon = '#' })
  local config = require('calendar.config')
  lu.assertEquals(config.get().mark_icon, '#')
end

return TestConfig


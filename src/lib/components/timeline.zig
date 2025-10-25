const std = @import("std");
const frame = @import("../data/frame.zig");
const rl = @import("raylib");
const defaults = @import("../defaults.zig");
const utils = @import("utils.zig");

const CellRect = struct {
    const Self = @This();

    is_active: bool,
    config: defaults.BaseConfig,
    aspect_dimensions: utils.IntegerRect,

    pub fn init(config: defaults.BaseConfig) Self {
        return Self{
            .is_active = false,
            .config = config,
            .aspect_dimensions = utils.calculateAspectScaleDimensionsRect(config.configStructAsIntegers(), config.ratio),
        };
    }

    fn updateAspectDimensions(self: *Self) void {
        self.aspect_dimensions = utils.calculateAspectScaleDimensionsRect(
            self.config.configStructAsIntegers(),
            self.config.ratio,
        );
    }
};

pub const Component = struct {
    const Self = @This();
    frames: ?*std.array_list.Managed(frame.Data),
    cells: std.array_list.Managed(CellRect),
    active: i32,
    config: defaults.BaseConfig,

    pub fn init(config: defaults.BaseConfig, allocator: std.mem.Allocator) Self {
        const cells = std.array_list.Managed(CellRect).init(allocator);
        return Self{ .config = config, .frames = null, .cells = cells, .active = 0 };
    }

    pub fn setFrames(self: *Self, frames: *std.array_list.Managed(frame.Data)) void {
        self.frames = frames;
    }

    fn drawCells(self: *Self) void {
        const timeline_cfg = defaults.Timeline.base_config;
        var i: usize = 0;
        while (i < self.cells.items.len) : (i += 1) {
            const cell = self.cells.items[i];
            const dims = cell.config.configStructAsIntegers();
            if (cell.config.x + cell.config.padding_x > timeline_cfg.width + timeline_cfg.x) break;
            // if (cell.x + cell.width  - CELL_PADDING < WINDOW_WIDTH) continue;
            if (self.active == i) {
                rl.drawRectangle(
                    dims.x + dims.padding_x - 5,
                    dims.y + dims.padding_y - 5,
                    dims.width - dims.padding_x + 10,
                    dims.height - dims.padding_y + 10,
                    .red,
                );
            }
            rl.drawRectangle(
                dims.x + dims.padding_x,
                dims.y + dims.padding_y,
                dims.width - dims.padding_x,
                dims.height - dims.padding_y,
                .white,
            );
        }
    }

    pub fn draw(self: *Self) void {
        if (self.cells.items.len == 0) return;
        const scaled_dimensions = self.config.configStructAsIntegers();
        rl.drawRectangle(
            scaled_dimensions.x,
            scaled_dimensions.y,
            scaled_dimensions.width,
            scaled_dimensions.height,
            .black,
        );
        self.drawCells();
    }

    pub fn update(self: *Self) !void {
        if (self.frames == null) return;
        self.updateCells() catch unreachable;
    }

    fn updateCells(self: *Self) !void {
        const scroll_movement = rl.getMouseWheelMove();

        const frames = self.frames orelse return;

        // Ensure cells match frames count
        while (self.cells.items.len < frames.items.len) {
            try self.cells.append(CellRect.init(buildCellConfig(self.cells.items.len)));
        }

        var i: usize = 0;
        while (i < self.cells.items.len) : (i += 1) {
            var cell = &self.cells.items[i];
            if (scroll_movement != 0) {
                cell.config.x += (scroll_movement / defaults.Window.base_config.width) * 800;
                // Only update aspect dimensions when config changes
                cell.updateAspectDimensions();
            }
            self.updateActiveCell(cell.*, &i);
        }
    }

    fn updateActiveCell(self: *Self, cell: CellRect, idx: *const usize) void {
        const mouse_pos = rl.getMousePosition();
        const mouse_clicked = rl.isMouseButtonPressed(rl.MouseButton.left);
        const x = @as(i32, @intFromFloat(mouse_pos.x));
        const y = @as(i32, @intFromFloat(mouse_pos.y));
        const scaled = cell.config.configStructAsIntegers();
        if (x >= scaled.x + scaled.padding_x and
            x <= scaled.x + scaled.width - scaled.padding_x and
            y >= scaled.y + scaled.padding_y and
            y <= scaled.y + scaled.height - scaled.padding_y and
            mouse_clicked)
        {
            self.active = @as(i32, @intCast(idx.*));
        }
    }

    pub fn addNewFrameAndCell(self: *Self) void {
        self.frames.append(frame.Data.init());
        self.cells.append(CellRect.init());
    }
};

fn buildCellsFromFrames(
    cells: std.array_list.Managed(CellRect),
    frames: std.array_list.Managed(frame.Data),
) void {
    for (0..frames.items.len) |i| {
        cells.append(CellRect.init(buildCellConfig(i)));
    }
}

fn buildCellConfig(idx: usize) defaults.BaseConfig {
    const available_height_pct = defaults.Timeline.base_config.height;
    const target_padding_y_pct: f32 = 3;
    const target_padding_x_pct: f32 = 2;

    const target_height_pct = available_height_pct * 0.6;
    const target_y_pct = (available_height_pct / 2) - (target_height_pct / 2) - (defaults.Timeline.base_config.padding_y * 2) + defaults.Timeline.base_config.y;
    const canvas_ratio = defaults.Canvas.base_config.ratio orelse 1;
    const target_width_pct = (target_height_pct / canvas_ratio) - (2 * target_padding_x_pct);

    const target_x_pct_unclamped = target_padding_x_pct + (target_padding_x_pct + target_width_pct) * @as(f32, @floatFromInt(idx));
    const target_x_pct = @min(target_x_pct_unclamped, 2000000.0);

    return defaults.BaseConfig{
        .container_name = "CellRect",
        .x = target_x_pct,
        .y = target_y_pct,
        .width = target_width_pct,
        .height = target_height_pct,
        .max_width = target_width_pct,
        .max_height = target_height_pct,
        .padding_x = target_padding_x_pct,
        .padding_y = target_padding_y_pct,
        .ratio = defaults.Canvas.base_config.ratio,
        .sticky = true,
        .sticky_anchor = null,
        .scale = false,
        .resizeable = false,
        .border_radius = 0.0,
    };
}

const std = @import("std");
const frame = @import("../data/frame.zig");
const rl = @import("raylib");
const defaults = @import("../defaults.zig");
const utils = @import("utils.zig");

const CellRect = struct {
    const Self = @This();

    is_active: bool,
    config: defaults.BaseConfig,

    pub fn init(config: defaults.BaseConfig) Self {
        return Self{
            .is_active = false,
            .config = config,
        };
    }
};

pub const Component = struct {
    const Self = @This();
    frames: ?*std.array_list.Managed(frame.Data),
    cells: std.array_list.Managed(CellRect),
    active: i32,
    config: defaults.BaseConfig,
    mouse_in_region: bool,

    pub fn init(config: defaults.BaseConfig, allocator: std.mem.Allocator) Self {
        const cells = std.array_list.Managed(CellRect).init(allocator);
        return Self{
            .config = config,
            .frames = null,
            .cells = cells,
            .active = 0,
            .mouse_in_region = false,
        };
    }

    pub fn setFrames(self: *Self, frames: *std.array_list.Managed(frame.Data)) void {
        self.frames = frames;
    }

    fn drawCells(self: *Self) void {
        // const timeline_cfg = defaults.Timeline.base_config;
        var i: usize = 0;
        while (i < self.cells.items.len) : (i += 1) {
            const cell = self.cells.items[i];
            const dims = cell.config.configStructAsIntegers();
            const timeline_dims = self.config.configStructAsIntegers();
            const screen_edge_limit = rl.getScreenWidth() + timeline_dims.x;
            if (dims.x + dims.padding_x > screen_edge_limit) break;
            // if (cell.x + cell.width  - CELL_PADDING < WINDOW_WIDTH) continue;
            if (self.active == i) {
                rl.drawRectangle(
                    dims.x + dims.padding_x - 5,
                    dims.y + dims.padding_y - 5,
                    dims.width - (dims.padding_x * 2) + 10,
                    dims.height - (dims.padding_y * 2) + 10,
                    .red,
                );
            }
            rl.drawRectangle(
                dims.x + dims.padding_x,
                dims.y + dims.padding_y,
                dims.width - (dims.padding_x * 2),
                dims.height - (dims.padding_y * 2),
                .white,
            );
        }
    }

    pub fn draw(self: *Self) void {
        if (self.cells.items.len == 0) return;
        const scaled_dimensions = self.config.configStructAsIntegers();
        // kinda janky config overrides since I need full-width
        rl.drawRectangle(
            scaled_dimensions.x,
            scaled_dimensions.y,
            rl.getScreenWidth(),
            scaled_dimensions.height,
            .black,
        );
        self.drawCells();
    }

    pub fn update(self: *Self) !void {
        if (self.frames == null) return;
        self.updateMouseInRegion();
        self.updateCells() catch unreachable;
    }

    pub fn updateMouseInRegion(self: *Self) !void {
        self.mouse_in_region = utils.isMouseInRegion(self.config.configStructAsIntegers());
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
            y <= scaled.y + scaled.height - scaled.padding_y)
        {
            rl.setMouseCursor(rl.MouseCursor.pointing_hand);
            if (mouse_clicked) {
                self.active = @as(i32, @intCast(idx.*));
            }
        } else {
            rl.setMouseCursor(rl.MouseCursor.arrow);
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
    const timeline_cfg = defaults.Timeline.base_config;
    const canvas_cfg = defaults.Canvas.base_config;
    const available_height_pct = timeline_cfg.height;
    const target_padding_y_pct: f32 = 2;
    const target_padding_x_pct: f32 = 2;

    const target_height_pct = available_height_pct - (target_padding_y_pct * 2);
    const target_y_pct = timeline_cfg.y + target_padding_y_pct;
    const canvas_ratio = canvas_cfg.ratio orelse 1;
    const target_width_pct = target_height_pct / canvas_ratio;
    // std.debug.print("target_height_pct: {}, canvas_ratio: {}, target_width_pct: {}\n", .{ target_height_pct, canvas_ratio, target_width_pct });
    const target_x_pct_unclamped = (target_width_pct + target_padding_x_pct) * @as(f32, @floatFromInt(idx)) + target_padding_x_pct;
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
        .ratio = canvas_cfg.ratio,
        .sticky = true,
        .sticky_anchor = null,
        .scale = false,
        .resizeable = false,
        .border_radius = 0.0,
    };
}

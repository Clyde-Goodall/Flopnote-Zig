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

pub const TimelineView = enum {
    Cells,
    Layers,
};

pub const Component = struct {
    const Self = @This();
    frames: ?*std.array_list.Managed(frame.Data),
    cells: std.array_list.Managed(CellRect),
    prev_active: usize,
    current_active: usize,
    config: defaults.BaseConfig,
    mouse_in_region: bool,
    theme_data: defaults.Theme,

    pub fn init(allocator: std.mem.Allocator) Self {
        const cells = std.array_list.Managed(CellRect).init(allocator);
        return Self{
            .config = defaults.Timeline.base_config,
            .frames = null,
            .cells = cells,
            .current_active = 0,
            .prev_active = 0,
            .mouse_in_region = false,
            .theme_data = defaults.Theme.init(),
        };
    }

    pub fn deinit(self: *Self) void {
        self.cells.deinit();
    }

    pub fn setFrames(self: *Self, frames: *std.array_list.Managed(frame.Data)) void {
        self.frames = frames;
    }

    fn drawCells(self: *Self) void {
        var i: usize = 0;
        while (i < self.cells.items.len) : (i += 1) {
            const cell = self.cells.items[i];
            var dims = cell.config.configStructAsIntegers();
            dims.x = dims.x + dims.padding_x;
            const timeline_dims = self.config.configStructAsIntegers();
            const screen_edge_limit = rl.getScreenWidth() + timeline_dims.x;
            if (dims.x + dims.padding_x > screen_edge_limit) break;
            // if (cell.x + cell.width  - CELL_PADDING < WINDOW_WIDTH) continue;
            if (self.current_active == i) {
                rl.drawRectangle(
                    dims.x - 5,
                    dims.y - 5,
                    dims.width + 10,
                    dims.height + 10,
                    self.theme_data.HIGHLIGHT,
                );
            }
            rl.drawRectangle(
                dims.x,
                dims.y,
                dims.width,
                dims.height,
                self.theme_data.PRIMARY,
            );
        }
    }

    pub fn draw(self: *Self) !void {
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
        try self.updateMouseInRegion();
        self.updateCells() catch unreachable;
    }

    pub fn updateMouseInRegion(self: *Self) !void {
        self.mouse_in_region = utils.isMouseInRegion(&self.config.configStructAsIntegers(), true, null);
    }

    fn updateCells(self: *Self) !void {
        const frames = self.frames orelse return;

        // Ensure cells match frames count
        while (self.cells.items.len < frames.items.len) {
            try self.cells.append(CellRect.init(buildCellConfig(self.cells.items.len)));
        }

        if (!self.mouse_in_region) return;
        const scroll_movement = rl.getMouseWheelMove();
        var i: usize = 0;
        while (i < self.cells.items.len) : (i += 1) {
            var cell = &self.cells.items[i];
            const is_hovered = utils.isMouseInRegion(&cell.config.configStructAsIntegers(), null, null);
            if (is_hovered) {
                const mouse_clicked = rl.isMouseButtonPressed(rl.MouseButton.left);
                if (mouse_clicked) {
                    self.swapActiveFrameInFrameArray(i);
                }
            }
            if (scroll_movement != 0) {
                cell.config.x += (scroll_movement / defaults.Window.base_config.width) * 800;
            }
        }
    }
    pub fn swapActiveFrameInFrameArray(self: *Self, idx: usize) void {
        self.prev_active = self.current_active;
        self.current_active = idx;
        self.frames.?.*.items[self.prev_active].active = false; // lol
        self.frames.?.*.items[self.current_active].active = true;
        std.debug.print("\nSet {} as active frame\n", .{idx});
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
    const target_padding_y_pct: f32 = 4;
    const target_padding_x_pct: f32 = 2;

    const target_height_pct = available_height_pct - (target_padding_y_pct * 2);
    const target_y_pct = timeline_cfg.y + target_padding_y_pct;
    const canvas_ratio = canvas_cfg.ratio orelse 1;
    const target_width_pct = target_height_pct / canvas_ratio;
    const target_x_pct_unclamped = (target_width_pct + target_padding_x_pct) * @as(f32, @floatFromInt(idx)) + target_padding_x_pct;
    const target_x_pct = @min(target_x_pct_unclamped, 2000000.0);

    return defaults.BaseConfig{
        .container_name = "CellRect",
        .maintain_aspect = true,
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

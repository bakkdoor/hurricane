class Storm {
  class OutputStream {
    def initialize: @component name: @name fields: @fields ([]);
    def emit: tuple anchors: anchors ([]) direct: direct (nil) {
      @component on: @name emit: tuple anchors: anchors direct: direct
    }

    def <- tuple {
      emit: tuple
    }
  }
}
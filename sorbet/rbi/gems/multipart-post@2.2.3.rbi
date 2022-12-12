# typed: true

# DO NOT EDIT MANUALLY
# This is an autogenerated file for types exported from the `multipart-post` gem.
# Please instead update this file by running `bin/tapioca gem multipart-post`.

# source://multipart-post//lib/multipart/post/composite_read_io.rb#77
CompositeIO = Multipart::Post::CompositeReadIO

module Multipart; end
module Multipart::Post; end

# Concatenate together multiple IO objects into a single, composite IO object
# for purposes of reading as a single stream.
#
# @example
#   crio = CompositeReadIO.new(StringIO.new('one'),
#   StringIO.new('two'),
#   StringIO.new('three'))
#   puts crio.read # => "onetwothree"
class Multipart::Post::CompositeReadIO
  # Create a new composite-read IO from the arguments, all of which should
  # respond to #read in a manner consistent with IO.
  #
  # @return [CompositeReadIO] a new instance of CompositeReadIO
  #
  # source://multipart-post//lib/multipart/post/composite_read_io.rb#36
  def initialize(*ios); end

  # Read from IOs in order until `length` bytes have been received.
  #
  # source://multipart-post//lib/multipart/post/composite_read_io.rb#42
  def read(length = T.unsafe(nil), outbuf = T.unsafe(nil)); end

  # source://multipart-post//lib/multipart/post/composite_read_io.rb#59
  def rewind; end

  private

  # source://multipart-post//lib/multipart/post/composite_read_io.rb#70
  def advance_io; end

  # source://multipart-post//lib/multipart/post/composite_read_io.rb#66
  def current_io; end
end

module Multipart::Post::Multipartable
  # source://multipart-post//lib/multipart/post/multipartable.rb#45
  def initialize(path, params, headers = T.unsafe(nil), boundary = T.unsafe(nil)); end

  # Returns the value of attribute boundary.
  #
  # source://multipart-post//lib/multipart/post/multipartable.rb#68
  def boundary; end

  private

  # source://multipart-post//lib/multipart/post/multipartable.rb#73
  def symbolize_keys(hash); end

  class << self
    # source://multipart-post//lib/multipart/post/multipartable.rb#31
    def secure_boundary; end
  end
end

module Multipart::Post::Parts; end

# Represents the epilogue or closing boundary.
class Multipart::Post::Parts::EpiloguePart
  include ::Multipart::Post::Parts::Part

  # @return [EpiloguePart] a new instance of EpiloguePart
  #
  # source://multipart-post//lib/multipart/post/parts.rb#142
  def initialize(boundary); end
end

# Represents a part to be filled from file IO.
class Multipart::Post::Parts::FilePart
  include ::Multipart::Post::Parts::Part

  # @param boundary [String]
  # @param name [#to_s]
  # @param io [IO]
  # @param headers [Hash]
  # @return [FilePart] a new instance of FilePart
  #
  # source://multipart-post//lib/multipart/post/parts.rb#93
  def initialize(boundary, name, io, headers = T.unsafe(nil)); end

  # @param boundary [String]
  # @param name [#to_s]
  # @param filename [String]
  # @param type [String]
  # @param content_len [Integer]
  # @param opts [Hash]
  #
  # source://multipart-post//lib/multipart/post/parts.rb#108
  def build_head(boundary, name, filename, type, content_len, opts = T.unsafe(nil)); end

  # Returns the value of attribute length.
  #
  # source://multipart-post//lib/multipart/post/parts.rb#87
  def length; end
end

# Represents a parametric part to be filled with given value.
class Multipart::Post::Parts::ParamPart
  include ::Multipart::Post::Parts::Part

  # @param boundary [String]
  # @param name [#to_s]
  # @param value [String]
  # @param headers [Hash] Content-Type and Content-ID are used, if present.
  # @return [ParamPart] a new instance of ParamPart
  #
  # source://multipart-post//lib/multipart/post/parts.rb#59
  def initialize(boundary, name, value, headers = T.unsafe(nil)); end

  # @param boundary [String]
  # @param name [#to_s]
  # @param value [String]
  # @param headers [Hash] Content-Type is used, if present.
  #
  # source://multipart-post//lib/multipart/post/parts.rb#72
  def build_part(boundary, name, value, headers = T.unsafe(nil)); end

  # source://multipart-post//lib/multipart/post/parts.rb#64
  def length; end
end

module Multipart::Post::Parts::Part
  # source://multipart-post//lib/multipart/post/parts.rb#42
  def length; end

  # source://multipart-post//lib/multipart/post/parts.rb#46
  def to_io; end

  class << self
    # @return [Boolean]
    #
    # source://multipart-post//lib/multipart/post/parts.rb#38
    def file?(value); end

    # source://multipart-post//lib/multipart/post/parts.rb#29
    def new(boundary, name, value, headers = T.unsafe(nil)); end
  end
end

# Convenience methods for dealing with files and IO that are to be uploaded.
class Multipart::Post::UploadIO
  # Create an upload IO suitable for including in the params hash of a
  # Net::HTTP::Post::Multipart.
  #
  # Can take two forms. The first accepts a filename and content type, and
  # opens the file for reading (to be closed by finalizer).
  #
  # The second accepts an already-open IO, but also requires a third argument,
  # the filename from which it was opened (particularly useful/recommended if
  # uploading directly from a form in a framework, which often save the file to
  # an arbitrarily named RackMultipart file in /tmp).
  #
  # @example
  #   UploadIO.new("file.txt", "text/plain")
  #   UploadIO.new(file_io, "text/plain", "file.txt")
  # @return [UploadIO] a new instance of UploadIO
  #
  # source://multipart-post//lib/multipart/post/upload_io.rb#43
  def initialize(filename_or_io, content_type, filename = T.unsafe(nil), opts = T.unsafe(nil)); end

  # Returns the value of attribute content_type.
  #
  # source://multipart-post//lib/multipart/post/upload_io.rb#27
  def content_type; end

  # Returns the value of attribute io.
  #
  # source://multipart-post//lib/multipart/post/upload_io.rb#27
  def io; end

  # Returns the value of attribute local_path.
  #
  # source://multipart-post//lib/multipart/post/upload_io.rb#27
  def local_path; end

  # source://multipart-post//lib/multipart/post/upload_io.rb#69
  def method_missing(*args); end

  # Returns the value of attribute opts.
  #
  # source://multipart-post//lib/multipart/post/upload_io.rb#27
  def opts; end

  # Returns the value of attribute original_filename.
  #
  # source://multipart-post//lib/multipart/post/upload_io.rb#27
  def original_filename; end

  # @return [Boolean]
  #
  # source://multipart-post//lib/multipart/post/upload_io.rb#73
  def respond_to?(meth, include_all = T.unsafe(nil)); end

  class << self
    # @raise [ArgumentError]
    #
    # source://multipart-post//lib/multipart/post/upload_io.rb#63
    def convert!(io, content_type, original_filename, local_path); end
  end
end

# source://multipart-post//lib/multipart/post/multipartable.rb#85
Multipartable = Multipart::Post::Multipartable

# source://multipart-post//lib/multipart/post/parts.rb#151
Parts = Multipart::Post::Parts

# source://multipart-post//lib/multipart/post/upload_io.rb#80
UploadIO = Multipart::Post::UploadIO

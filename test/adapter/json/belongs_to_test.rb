require 'test_helper'

module ActiveModel
  class Serializer
    class Adapter
      class Json
        class BelongsToTest < Minitest::Test
          def setup
            @post = Post.new(id: 42, title: 'New Post', body: 'Body')
            @anonymous_post = Post.new(id: 43, title: 'Hello!!', body: 'Hello, world!!')
            @comment = Comment.new(id: 1, body: 'ZOMG A COMMENT')
            @post.comments = [@comment]
            @anonymous_post.comments = []
            @comment.post = @post
            @post.author = @author
            @anonymous_post.author = nil

            @serializer = CommentSerializer.new(@comment)
            @adapter = ActiveModel::Serializer::Adapter::Json.new(@serializer)
          end

          def test_includes_post
            assert_equal({id: 42, title: 'New Post', body: 'Body'}, @adapter.serializable_hash[:post])
          end

          def test_include_nil_author
            serializer = PostSerializer.new(@anonymous_post)
            adapter = ActiveModel::Serializer::Adapter::Json.new(serializer)

            assert_equal({title: "Hello!!", body: "Hello, world!!", id: 43, comments: [], author: nil}, adapter.serializable_hash)
          end
        end
      end
    end
  end
end

# coding: utf-8
require 'spec_helper'

describe Content do
  before do
    #@blog = stub_model(Blog)
    @blog = Factory(:blog)#stub_model(Blog)
    Blog.stub(:default) { @blog }
    @content = Content.create
  end

  describe '#merge' do

    context 'when two articles are merged successfully' do
      let(:article_1) { Factory.create(:article) }
      let(:article_2) { Factory.create(:article) }

      before do
        @result = Article.merge(article_1.id, article_2.id)
      end

      it 'should have the title of the first article' do
        expect(@result.title.should).to eq(article_1.title)
      end

      it 'should have a user of the first article associated' do
        expect(@result.user).to eq(article_1.user)
      end

      it 'should have the combined body of the old articles' do
        expected_body = article_1.body + "<br/>" + article_2.body

        expect(@result.body.should).to eq(expected_body)
      end

      it 'should have the author of the first article' do
        expect(@result.author.should).to eq(article_1.author)
      end

      it 'should combine comments of old articles to the new one' do
        expected_comments = [article_1.comments, article_2.comments].flatten
        expect(@result.comments.should).to eq(expected_comments)
      end

      it 'should delete the old articles' do
        expect { Article.find(article_1) }.to raise_error(ActiveRecord::RecordNotFound)
        expect { Article.find(article_2) }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe "#short_url" do
    before do
      @content.published = true
      @content.redirects.build :from_path => "foo", :to_path => "bar"
      @content.save
    end

    describe "normally" do
      before do
        @blog.stub(:base_url) { "http://myblog.net" }
      end

      it "returns the blog's base url combined with the redirection's from path" do
        @content.short_url.should == "http://myblog.net/foo"
      end
    end

    describe "when the blog is in a sub-uri" do
      before do
        @blog.stub(:base_url) { "http://myblog.net/blog" }
      end

      it "includes the sub-uri path" do
        @content.short_url.should == "http://myblog.net/blog/foo"
      end
    end
  end
end


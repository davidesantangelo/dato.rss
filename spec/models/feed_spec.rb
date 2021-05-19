require 'rails_helper'

RSpec.describe Feed, type: :model do
  let(:feed) { Feed.new }

  it { should have_many(:entries) }
  it { should have_many(:logs) }

  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:url) }
  end

  it 'is not valid without a title' do
    feed = Feed.new(title: nil)
    expect(feed).to_not be_valid
  end

  it 'is valid with valid attributes' do
    feed.title = 'title'
    feed.description = 'description'
    feed.url = 'http://url/rss2.0.xml'
    expect(feed).to be_valid
  end

  it 'is not valid without a URL' do
    expect(feed).to_not be_valid
  end

  it 'is not valid without a title' do
    feed.url = 'http://url/rss2.0.xml'
    expect(feed).to_not be_valid
  end
end

require 'rails_helper'

RSpec.describe Entry, type: :model do
  let(:feed) { Feed.new(url: 'http://url/rss2.0.xml') }
  let(:entry) { Entry.new }

  it { should belong_to(:feed) }

  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:url) }
  end

  it 'is valid with valid attributes' do
    entry.feed = feed
    entry.title = 'title'
    entry.body = 'body'
    entry.url = 'https://url/?rss'
    expect(entry).to be_valid
  end

  it 'is not valid without a URL' do
    expect(entry).to_not be_valid
  end

  it 'is not valid without a title' do
    entry.url = 'https://url/?rss'
    expect(entry).to_not be_valid
  end
end

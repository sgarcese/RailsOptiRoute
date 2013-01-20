require 'spec_helper'

describe GoogleAPI::GoogleLocation do

  context "initializing without arguments" do
    it "raises an exception" do
      expect { GoogleAPI::GoogleLocation.new }.to raise_error
    end
  end

  context "initializing with 3 arguments or more" do
    it "raises an exception" do
      expect { GoogleAPI::GoogleLocation.new("test", "test", "test") }.to raise_error
    end
  end

end

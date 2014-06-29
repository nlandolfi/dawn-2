
if ENV["COVERAGE"]
  require "simplecov"; SimpleCov.start
end

require_relative "./spec_helper"

describe Dawn::Task do
  it "exists" do
    expect(defined? Dawn::Task).to be_truthy
  end

  it "creates" do
    expect(Dawn::Task.create).to_not eq(nil)
  end

  # --- Core {{{

  describe "core" do

    describe "Task#key" do

      it "returns the symbolized lowercase version of the task's name" do
        task = Dawn::Task.new(name: "Task")
        expect(task.key).to eq(:task)
      end

      it "can handle spaced task names" do
        task = Dawn::Task.new(name: "My Task Name")
        expect(task.key).to eq(:"my task name")
      end

    end

  end

  # --- }}}

  # --- Dependencies {{{

  describe "dependencies" do

    before(:all) do
      @dependency = Dawn::Task.new(name: "Dependency")
      @task = Dawn::Task.new(dependencies: [@dependency])
    end

    after(:all) do
      @dependency.destroy
      @task.destroy
    end

    it "supports dependencies" do
      expect(@task).to_not eq(nil)
      expect(@task.dependencies).to be_kind_of(ActiveRecord::Associations::CollectionProxy)
      expect(@task.dependencies.first).to be(@dependency)
    end

    describe "Task#add_dependency" do
      before(:all) do
        @dependency_two = Dawn::Task.new(name: "Dependeny Two")
        @result = @task.add_dependency(@dependency_two)
      end

      it "has dependencies array" do
        expect(@task.dependencies).to be_kind_of(ActiveRecord::Associations::CollectionProxy)
      end

      it "now has two dependencies" do
        expect(@task.dependencies.size).to eq(2)
      end

      it "has the new dependency as the last dependency" do
        expect(@task.dependencies.last).to eq(@dependency_two)
      end

      it "returns the dependencies" do
        expect(@task.dependencies).to eq(@result)
      end

      after(:all) do
        @task.remove_dependency(@dependency_two)
      end
    end

    describe "Task#remove_dependency" do
      before (:all) do
        @result = @task.remove_dependency(@dependency)
      end

      it "has dependencies array" do
        expect(@task.dependencies).to be_kind_of(ActiveRecord::Associations::CollectionProxy)
      end

      it "now has zero dependencies" do
        expect(@task.dependencies.size).to eq(0)
      end

      it "returns the dependencies" do
        expect(@task.dependencies).to eq(@result)
      end

      it "doesn't choke on removal of a task that is not a dependency" do
        @result = @task.remove_dependency(@dependency)
        expect(@task.dependencies).to eq(@result)
      end

      after(:all) do
        @result = @task.add_dependency(@dependency)
      end

    end

    describe "Task#dependencies? || Task#has_dependencies?" do
      it "has_dependencies returns same value as dependencies?" do
        expect(@task.dependencies?).to eq(@task.has_dependencies?)
      end

      it "returns true if has dependencies" do
        expect(@task.dependencies?).to eq(true)
        expect(@task.has_dependencies?).to eq(true)
      end

      it "returns false if no dependencies" do
        @task.remove_dependency(@dependency)
        expect(@task.dependencies?).to eq(false)
        expect(@task.has_dependencies?).to eq(false)
        @task.add_dependency(@dependency)
      end
    end

    describe "Task#no_dependencies? || Task#has_no_dependencies()" do
      it "has_no_dependencies has teh same value as no_dependencies?" do
        expect(@task.no_dependencies?).to eq(@task.has_no_dependencies?)
      end

      it "has the opposite value of dependencies?" do
        expect(@task.dependencies?).to eq(!@task.no_dependencies?)
        expect(@task.has_dependencies?).to eq(!@task.has_no_dependencies?)
      end

      it "returns false if dependencies" do
        expect(@task.no_dependencies?).to eq(false)
      end

      it "returns true if no dependencies" do
        @task.dependencies = []
        expect(@task.no_dependencies?).to eq(true)
      end
    end

  end

  # --- }}}

end


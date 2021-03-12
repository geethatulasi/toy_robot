class Api::RobotController < ApplicationController

  def create
    @max_x = @max_y = 4
    @facings = ["NORTH","SOUTH","EAST","WEST"]
    # binding.pry
    if params[:robot].present?
      @robot_params = params[:robot]
      commands_length =@robot_params.length
      binding.pry
      if @robot_params[0].include?("PLACE")
        assign_params
        if check_position_valid?
        # binding.pry
          for i in 1...commands_length do
            puts @robot_params[i]
            command = @robot_params[i] 
            binding.pry
            case command
            when "MOVE"
              move_robot
            when "REPORT"
              generate_report
            when "LEFT"
              move_left
            when "RIGHT"
              move_right
            else
              break
            end
          end
        else
          render json: {error: "robot place commands are not valid"}
        end
      end
    else
      render json:{message: "Please send robot commands"}
    end
  end

  private

  def assign_params
    @x = @robot_params[0][1]
    @y = @robot_params[0][2]
    @f = @robot_params[0][3]
  end

  def check_position_valid?
    if  @x > 0 && @x <= @max_x && @y > 0 && @y <= @max_y && @facings.include?(@f)
      return true
    else
      return false
    end
  end

  def generate_report
    # binding.pry
    report =  [@x,@y,@f]
    render json:{report:report} 
  end

  def move_robot
    # binding.pry
    facing = @f
    case facing
    when "NORTH"
      @y = @y + 1 unless @y >= @max_y
    when "SOUTH"
      @y  = @y - 1 unless @y ==0
    when "WEST"
      @x = @x - 1 unless @x == 0
    when "EAST"
      # binding.pry
      @x = @x + 1 unless @x >= @max_x
    else
    end
  end

  def move_left
    facing = @f 
    case facing
    when "NORTH"
      @f = "WEST"
    when "WEST"
      @f = "SOUTH"
    when "SOUTH"
      @f = "EAST"
    when "EAST"
      @f = "NORTH"
    else
    end
  end

  def move_right
    facing = @f
    case facing
    when "NORTH"
      @f = "EAST"
    when "EAST"
      @f = "SOUTH"
    when "SOUTH"
      @f = "WEST"
    when "WEST"
      @f = "NORTH"
    else
    end
  end

end

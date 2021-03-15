class Api::RobotController < ApplicationController

  def create
    @max_x = @max_y = 4
    @facings = ["NORTH","SOUTH","EAST","WEST"]
    # binding.pry
    if params[:robot].present?
      @robot_params = params[:robot]
      commands_length =@robot_params.length
      # binding.pry
      if params[:robot][0].include?("PLACE")
        for i in 0...commands_length do
          if @robot_params[i].include?("PLACE")
            @row = i
            temp_params
            binding.pry
            if check_position_valid?
              assign_params
            else
              render json:{error: "Place commands are not valid"}
            end
          else
            if check_position_valid?
              # assign_params
            # binding.pry
                # puts @robot_params[i]
                command = @robot_params[i]
                # binding.pry
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
            # else
            #   render json: {error: "robot place commands are not valid"}
            end
          end
        end
      end

    else
      render json:{message: "Please send robot commands"}
    end
  end

  private

  def temp_params
    @tem_x = @robot_params[@row][1]
    @tem_y = @robot_params[@row][2]
    @tem_f = @robot_params[@row][3]
  end

  def assign_params
    @x = @tem_x
    @y = @tem_y
    @f = @tem_f
  end

  def check_position_valid?
    if  @tem_x > 0 && @tem_x <= @max_x && @tem_y > 0 && @tem_y <= @max_y && @facings.include?(@tem_f)
    binding.pry
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

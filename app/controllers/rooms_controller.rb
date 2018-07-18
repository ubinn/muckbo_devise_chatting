class RoomsController < ApplicationController
  before_action :set_room, only: [:show, :edit, :update, :destroy]

  # GET /rooms
  # GET /rooms.json
  def index
    @rooms = Room.all
  end

  # GET /rooms/1
  # GET /rooms/1.json
  def show
  end

  # GET /rooms/new
  def new
    @room = Room.new
  end

  # GET /rooms/1/edit
  def edit
  end

  # POST /rooms
  # POST /rooms.json
  def create
    puts room_params
    
   @room = Room.new(room_params)
    puts @room
  #  room = Room.new
  #  room.room_title =params[:room_title]
  #  room.save
     
        
  #  redirect_to "/rooms/#{room.id}"

    respond_to do |format|
      if @room.save
        format.html { redirect_to @room, notice: 'Room was successfully created.' }
        format.json { render :show, status: :created, location: @room }
      else
        format.html { render :new }
        format.json { render json: @room.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /rooms/1
  # PATCH/PUT /rooms/1.json
  def update
    respond_to do |format|
      if @room.update(room_params)
        format.html { redirect_to @room, notice: 'Room was successfully updated.' }
        format.json { render :show, status: :ok, location: @room }
      else
        format.html { render :edit }
        format.json { render json: @room.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /rooms/1
  # DELETE /rooms/1.json
  def destroy
    @room.destroy
    respond_to do |format|
      format.html { redirect_to rooms_url, notice: 'Room was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def sign_up
  end
  
  def user_create
      @user = User.create(email: params[:email], password: params[:password], nickname: params[:nickname], major: params[:major], another_major: params[:another_major], sex: params[:sex])
      ContactMailer.contact_mail(@user).deliver_now
      redirect_to "/users/sign_in"
  end

  def sign_in
  end
  
  def log_in
    # 유저가 입력한 ID, PW를 바탕으로
    # 실제로 로그인이 이루어지는 곳
    # id = params[:email]
    # pw = params[:password]
    # user = User.find_by_user_id(id)
    # if !user.nil? and user.password.eql?(pw)
      # 해당 user_id로 가입한 유저가 있고, 패스워드도 일치하는 경우
      # session[:current_user] = user.id
    if user_signed_in?
      redirect_to '/'
    else
      # 가입한 user_id가 없거나, 패스워드가 틀린경우
      # flash[:error] = "가입된 유저가 아니거나, 비밀번호가 틀립니다."
      # flash[:error]
      redirect_to '/users/sign_in'
    end
  end
  
  def logout
    session.delete(:current_user)
    redirect_to '/'
  end

  def hashtags
    tag = Tag.find_by(name: params[:name])
    @rooms = tag.rooms
    @tag =tag.name
  end




  private
    # Use callbacks to share common setup or constraints between actions.
    def set_room
      @room = Room.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def room_params
      @room = params.require(:room).permit(:room_title, :max_count, :start_time_hour, :start_time_min, :food_type, :room_type, :hashtag, :user_id, :password)
    # {room_title: params[:room][:room]
    end
    
end


 
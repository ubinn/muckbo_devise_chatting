class RoomsController < ApplicationController
  before_action :set_room, only: [:show, :edit, :update, :destroy, :user_exit_room, :is_user_ready, :chat, :open_chat]
  before_action :authenticate_user!, except: [:index]

  # GET /rooms
  # GET /rooms.json
  def index
    @rooms = Room.page params[:page]
    @rooms.where(admissions_count: 0).destroy_all
    
  end

  # GET /rooms/1
  # GET /rooms/1.json
  def show
   
    respond_to do |format|
      if @room.chat_started?
       format.html { render 'chat' }
      else
        if @room.max_count > @room.admissions_count
          @room.user_admit_room(current_user) unless current_user.joined_room?(@room)  
          format.html { render 'show' }
        else
          if @room.admissions.exists?(user_id: current_user.id)
            format.html { render 'show' }
          else
            format.html {render 'alert'}
          end  
        end      
      end
    end

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
   @room = Room.new(room_params)
   @room.master_id = current_user.email
   
   respond_to do |format|
      if @room.save
       @room.user_admit_room(current_user) #room.rb
       p "create의 user_admit_room 실행"
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
  
  ### 채팅 ###
  def user_exit_room
    p "유저나가기 컨트롤러까지는 옴"
    @room.user_exit_room(current_user)
    # @room.zero_room_delete(current_user)
    if @room.room_state 
      @room.update(room_state: false)
    end
  end
  
   def is_user_ready
   if current_user.is_ready?(@room) # 현재 레디상태라면
     render js: "console.log('이미 레디상태'); location.reload();"
   else  # 현재 레디상태가 아니라면
     @room.user_ready(current_user) # 현재유저의 레디상태 바꿔주기
     render js: "console.log('레디상태로 바뀌었습니다.'); location.reload();"
     # 현재 레디한 방 외에 모든방의 레디해제
     current_user.admissions.where.not(room_id: @room.id).destroy_all
      Room.where(admissions_count: 0).destroy_all
     # if
   end
   
 end
 
 def chat
   @room_id = @room.id
   p "으쌰"
    @room.chats.create(user_id: current_user.id, message: params[:message])
 end
 
 def open_chat
   p "오픈챗 됬다."
   @room.update(room_state: true)
   Pusher.trigger("room_#{@room.id}", 'chat_start', {})
   Pusher.trigger("room_#{@room.id}")
 end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_room
      @room = Room.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def room_params
      @room = params.require(:room).permit(:room_title, :max_count, :room_state, :admissions_count, :meet_time_end, :start_time_hour, :start_time_min, :food_type, :room_type, :hashtag)
    # {room_title: params[:room][:room]
    end
    
    # def user_params
    #   #email: params[:email], password: params[:password], nickname: params[:nickname], major: params[:major], another_major: params[:another_major], sex: params[:sex]
    #   @user = params.require(:user).permit(:email, :password, :nickname, :major, :another_major. :sex)
    # end
end


 
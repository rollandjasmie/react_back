class ApplicationController < ActionController::API
    # before_action :authorized
    include Response
    include ExceptionHandler
  
  def encode_token(payload)
    # Time now + Hour define in .env * 3600 seconds
    payload[:exp] = Time.now.to_i + ENV["EXPIRATION_TIME"].to_i * 3600
    JWT.encode(payload, ENV['SECRET_KEY'])
  end

  def auth_header
    # { Authorization: 'Bearer <token>' }
    request.headers['Authorization']
  end

  def decoded_token
    if auth_header
      token = auth_header.split(' ')[1]
      # header: { 'Authorization': 'Bearer <token>' }
      begin
        JWT.decode(token, ENV['SECRET_KEY'], true, algorithm: 'HS256')
      rescue JWT::DecodeError
        nil
      rescue JWT::ImmatureSignature
        nil
      rescue JWT::InvalidIssuerError
        nil
      end
    end
  end

  def current_user
    if decoded_token
      user_id = decoded_token[0]['user_id']
      admin =  decoded_token[0]['admin']
      
      if admin == false
        @user = User.find_by(id: user_id)
      elsif admin == true
        @user = AdminRun.find_by(id: user_id)
      end
    end
  end

  def logged_in?
    !!current_user
  end

  def authorized
    render json: {
      success: "false", 
      message: 'Please log in' 
    }, status: :unauthorized unless logged_in?
  end
   
end

class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.all
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
  end

  # GET /posts/new
  def new
    @post = Post.new
    @posts = Post.all
    @posts_count = @posts.size
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(post_params)
    
    respond_to do |format|
      if @post.save
        send_msg(@post)
        format.html { redirect_to new_post_path, notice: 'Post was successfully created.' }
        format.json { render :show, status: :created, location: @post }
        format.js
      else
        format.html { render :new }
        format.json { render json: @post.errors, status: :unprocessable_entity }
        format.js
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url, notice: 'Post was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def send_msg(post)
      require 'gcm'
      gcm = GCM.new('AIzaSyAPNI6bfVjElDR0hVK8aco9Am_An5pmmO4')
      registration_ids= ['APA91bFamLkdNBuXiueXQmDtXU_PoYwEzrUcvxYSlQWBJiWCETNHO3186m3tTLNG6Eyz4d72Vq2SIXk210vI5MXE_rHn0LmvuduRM7baWvA_ro2R2-3qWc5hMu3dc0S41ZU6lBD3SkaJFEbKsyScpn1Y2BQPqgYwxg'] # an array of one or more client registration IDs
       options = {
          'data' => {
            'message' => post.message
          },
            'collapse_key' => 'updated_state'
        }
      response = gcm.send_notification(registration_ids, options)
      p "response"
      p response
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:message)
    end
end

# coding: utf-8
class GroupsController < ApplicationController
  # GET /groups
  # GET /groups.json
  def index
    @groups = Group.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @groups }
    end
  end

  # GET /groups/1
  # GET /groups/1.json
  def show
    @user = User.find_by_id(current_user.id)
    @group = Group.find(params[:id])
    
    @membersize = @group.members.size
    count = 0
    @memberarray = [0]

    while count < @membersize
      @memberarray[count] = User.find_by_id(@group.members[count])
      count += 1
    end

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @group }
    end
  end

  # GET /groups/new
  # GET /groups/new.json
  def new
    @user = User.find_by_id(current_user.id)
    @group = Group.new
    

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @group }
    end
  end

  # GET /groups/1/edit
  def edit
    @group = Group.find(params[:id])
  end

  # POST /groups
  # POST /groups.json
  def create
    @group = Group.new(params[:group])
    user = User.find_by_id(current_user.id)
    
    # グループメンバーを保存
    @group.members = [current_user.id]

    respond_to do |format|
      if @group.save
        user.currentgroupid = @group.id
        user.save
        format.html { redirect_to :controller =>"accounts", :action => "index"}
      else
        format.html { render action: "new" }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /groups/1
  # PUT /groups/1.json
  def update
    @group = Group.find(params[:id])

    respond_to do |format|
      if @group.update_attributes(params[:group])
        format.html { redirect_to @group, notice: 'Group was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /groups/1
  # DELETE /groups/1.json
  def destroy
    @group = Group.find(params[:id])
    @group.destroy

    respond_to do |format|
      format.html { redirect_to groups_url }
      format.json { head :no_content }
    end
  end
  
  def consent
    @user = User.find_by_id(current_user.id)
    @group = Group.find_by_id(@user.currentgroupid)
    # グループ上限に達している場合はホームにリダイレクト
    if @group.members.size >= 5
      redirect_to root_path
    end
  end
  
  def consentsend
    user = User.find_by_id(current_user.id)
    group = Group.find_by_id(user.currentgroupid)
    # グループ上限に達している場合はホームにリダイレクト
    if group.members.size >= 5
      redirect_to root_path
    end
    otheruser = User.find_by_username(params[:q][0])
    
    if otheruser.blank?
      flash[:notice] = "存在しないIDです。"
    else
      if otheruser.consentgroup.blank?
        otheruser.consentgroup = [user.currentgroupid]
      else
        otheruser.consentgroup.unshift(user.currentgroupid)
      end
      
      otheruser.save
      flash[:notice] = "紹介依頼を出しました。"
    end
  
    redirect_to action: "consent"
  end
  
  def withdrawal
    user = User.find_by_id(current_user.id)
    group = Group.find_by_id(user.currentgroupid)
    
    group.members.delete(current_user.id)
    group.save
    user.currentgroupid = 0
    user.save
    
    redirect_to root_path
  end
  
end

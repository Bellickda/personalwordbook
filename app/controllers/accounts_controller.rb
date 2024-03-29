# coding: utf-8
class AccountsController < ApplicationController
  require 'net/http'
  require 'uri'
  require 'rubygems'
  require 'hpricot'
  require 'open-uri'
  require 'kconv'
  require 'resolv-replace'
  require 'timeout'
  before_filter :authenticate_user!

  # GET /accounts
  # GET /accounts.json
  def index
    #@accounts = Account.where('user_id = ?', current_user.id)
    @user = User.find_by_id(current_user.id)
    
    # 紹介依頼がある場合の処理
    if @user.consentgroup.present?
      @consentsize = @user.consentgroup.size
      count = 0
      @consentarray = [0]
      # 依頼数分のデータを格納する。
      while count < @consentsize
        @consentarray[count] = Group.find_by_id(@user.consentgroup[count])
        count += 1
      end
    end
    
    if @user.currentgroupid == 0
      render 'index_no_group'
    else
      @accounts = Account.where('groupid = ?', @user.currentgroupid).order("created_at DESC")
      @group = Group.find_by_id(@user.currentgroupid)
      
      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @accounts }
      end
    end
   end

  # GET /accounts/1
  # GET /accounts/1.json
  def show
    @account = Account.find(params[:id])
    if @account.user_id != current_user.id
      raise Forbidden
    end
    account_last = Account.find(:last)
    account_first = Account.find(:first)
    next_id = @account.id
    previous_id = @account.id
    
    
    while(account_last.id >= next_id)
      next_id += 1
      @next = Account.where('id = ? AND user_id = ?',next_id,current_user.id)
        if @next.present?
          @next = Account.find_by_id(next_id)
          break
        end
    end
    
    while(account_first.id <= previous_id)
      previous_id -= 1
      @previous = Account.where('id = ? AND user_id = ?',previous_id,current_user.id)
      if @previous.present?
        @previous = Account.find_by_id(previous_id)
        break
      end
    end
    
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @account }
    end
  end

  # GET /accounts/new
  # GET /accounts/new.json
  def new
    @user = User.find_by_id(current_user.id)
    @group = Group.find_by_id(@user.currentgroupid)
    @account = Account.new
    
   

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @account }
    end
  end

  # GET /accounts/1/edit
  def edit
    @user = User.find_by_id(current_user.id)
    @group = Group.find_by_id(@user.currentgroupid)
    @account = Account.find(params[:id])
    if @account.user_id != current_user.id
      raise Forbidden
    end
  end

  # POST /accounts
  # POST /accounts.json
  def create
    @account = Account.new(params[:account])
    @account.user = User.find_by_id(current_user.id)
    user = User.find_by_id(current_user.id)
    @account.groupid = user.currentgroupid

    respond_to do |format|
      if @account.save
        if @account.tmp.present?
          comment = Comment.new
          comment.accounts_id = @account.id
          comment.comment = @account.tmp
          comment.name = user.username
          comment.save
        end
        
        #current_user.twitter.update(@account.content) if params[:twitter] == 'yes'
        #if params[:facebook] == 'yes'
        #  current_user.facebook.feed!(:message => "test",
        #                              :link => "http://moonkey.jp",
        #                              :name => "TEST",
        #                              :description => "test")
        #end
        format.html { redirect_to accounts_url }
        format.json { render json: @account, status: :created, location: @account }
      else
        format.html { render action: "new" }
        format.json { render json: @account.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /accounts/1
  # PUT /accounts/1.json
  def update
    @account = Account.find(params[:id])

    respond_to do |format|
      if @account.update_attributes(params[:account])
        #current_user.twitter.update(@account.content) if params[:twitter] == 'yes'
        #if params[:facebook] == 'yes'
        #  current_user.facebook.feed!(:message => "test",
        #                              :link => "http://moonkey.jp",
        #                              :name => "TEST",
        #                              :description => "test")
        #end
        format.html { redirect_to accounts_url }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @account.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /accounts/1
  # DELETE /accounts/1.json
  def destroy
    @account = Account.find(params[:id])
    comments = Comment.where('accounts_id = ?',@account.id)
    comments.destroy_all
    if @account.user_id != current_user.id
      raise Forbidden
    end
    
    @account.destroy

    respond_to do |format|
      format.html { redirect_to accounts_url }
      format.json { head :no_content }
    end
  end
  
  def consentaccept
    
    user = User.find_by_id(current_user.id)
    group = Group.find_by_id(user.consentgroup[params[:id].to_i])
    if group.members.size >= 5
      redirect_to root_path
    end
    
    user.currentgroupid = user.consentgroup[params[:id].to_i]
    user.consentgroup.delete_at(params[:id].to_i)
    user.save
    
    group.members.unshift(current_user.id)
    group.save
    
    redirect_to accounts_path
  end
  
  def consentdestroy
    user = User.find_by_id(current_user.id)
    user.consentgroup.delete_at(params[:id].to_i)
    user.save
    redirect_to accounts_path
  end
  
  
  #def twitter
  #  @account = Account.find(params[:id])
  #  current_user.twitter.update(@account.content)
  #  redirect_to accounts_path
  #end
  
  def facebook
    @account = Account.find(params[:id])
    current_user.facebook.feed!(:message => @account.content,
                                      :link => "http://personaldiarymoonkey.herokuapp.com/",
                                      :name => "Personal Diary",
                                      :description => "いつでもどこでも自分だけの日記が書けるそれがPersonalDiary")
    redirect_to accounts_path
  end
  
  def search
    @account = Account.new
    @account.url = params[:url]
    begin
      doc = timeout(30){Hpricot(open(@account.url).read)}
    rescue URI::InvalidURIError
    rescue OpenURI::HTTPError
    rescue SocketError
    rescue Errno::ENOENT
    rescue RuntimeError
    rescue TimeoutError
    end
    @account.title = doc.search('title').first.innerText.strip.toutf8
    description = doc.search('meta[@name=description]').first
    @account.content = description ? description.get_attribute('content').strip.toutf8 : ""

  
  end
  
  def search2
    
    @other = Other.find_by_id(current_user.id)
    # カテゴリを選択させる
    @test = Hash::new
    count = 0
    @other.categoryarray.each do |a|
      if count == 0
        @test['全て'] = 0
      else
        @test[@other.categoryarray[count]] = @other.categoryarray[count]
      end
      count += 1
     end
    
     @accounts = Account.where('user_id = ? AND title like ? OR content like ?', current_user.id, "%"+params[:q]+"%", "%"+params[:q]+"%")
    
    render
  end
  
  def newcomment
    account = Account.find_by_id(params[:id])
    user = User.find_by_id(current_user.id)
    comment = Comment.new
    comment.accounts_id = account.id
    comment.comment = params[:q][0]
    comment.name = user.username
    comment.save
    redirect_to root_path
  end

  private
  def fetch(uri_str, limit = 10)
    raise ArgumentError, 'HTTP redirect too deep' if limit == 0
    
    response = Net::HTTP.get_response(URI.parse(uri_str))
    
    case response
    when Net::HTTPSuccess
      response
    when Net::HTTPRedirection
      fetch(response['location'], limit - 1)
    else
      response.value
    end
  end
end

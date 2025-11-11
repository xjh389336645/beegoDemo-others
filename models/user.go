package models

import (
	"errors"
	"time"

	"github.com/beego/beego/v2/client/orm"
)

// User 用户模型
type User struct {
	Id       int       `orm:"auto" json:"id"`
	Username string    `orm:"size(100);unique" json:"username"`
	Email    string    `orm:"size(100);unique" json:"email"`
	Password string    `orm:"size(255)" json:"password"`
	Avatar   string    `orm:"size(255);null" json:"avatar"`
	Status   int       `orm:"default(1)" json:"status"` // 1:正常 0:禁用
	Created  time.Time `orm:"auto_now_add;type(datetime)" json:"created"`
	Updated  time.Time `orm:"auto_now;type(datetime)" json:"updated"`
}

// TableName 设置表名
func (u *User) TableName() string {
	return "users"
}

// AddUser 添加用户
func AddUser(user *User) error {
	o := orm.NewOrm()

	// 检查用户名是否已存在
	exist := o.QueryTable("users").Filter("username", user.Username).Exist()
	if exist {
		return errors.New("用户名已存在")
	}

	// 检查邮箱是否已存在
	exist = o.QueryTable("users").Filter("email", user.Email).Exist()
	if exist {
		return errors.New("邮箱已存在")
	}

	_, err := o.Insert(user)
	return err
}

// GetUser 根据ID获取用户
func GetUser(id int) (*User, error) {
	o := orm.NewOrm()
	user := &User{Id: id}
	err := o.Read(user)
	if err != nil {
		return nil, err
	}
	return user, nil
}

// GetUserByUsername 根据用户名获取用户
func GetUserByUsername(username string) (*User, error) {
	o := orm.NewOrm()
	user := &User{}
	err := o.QueryTable("users").Filter("username", username).One(user)
	if err != nil {
		return nil, err
	}
	return user, nil
}

// GetAllUsers 获取所有用户
func GetAllUsers(page, pageSize int) ([]*User, int64, error) {
	o := orm.NewOrm()
	var users []*User

	qs := o.QueryTable("users")

	// 获取总数
	total, err := qs.Count()
	if err != nil {
		return nil, 0, err
	}

	// 分页查询
	offset := (page - 1) * pageSize
	_, err = qs.OrderBy("-id").Limit(pageSize, offset).All(&users)
	if err != nil {
		return nil, 0, err
	}

	return users, total, nil
}

// UpdateUser 更新用户信息
func UpdateUser(user *User) error {
	o := orm.NewOrm()
	_, err := o.Update(user)
	return err
}

// DeleteUser 删除用户
func DeleteUser(id int) error {
	o := orm.NewOrm()
	user := &User{Id: id}
	_, err := o.Delete(user)
	return err
}

// ValidateUser 验证用户登录
func ValidateUser(username, password string) (*User, error) {
	user, err := GetUserByUsername(username)
	if err != nil {
		return nil, errors.New("用户不存在")
	}

	// 这里应该使用加密后的密码比较，为了演示简化处理
	if user.Password != password {
		return nil, errors.New("密码错误")
	}

	if user.Status != 1 {
		return nil, errors.New("用户已被禁用")
	}

	return user, nil
}

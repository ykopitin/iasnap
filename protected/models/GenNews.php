<?php

/**
 * This is the model class for table "gen_news".
 *
 * The followings are the available columns in table 'gen_news':
 * @property integer $id
 * @property string $publicationDate
 * @property string $title
 * @property string $summary
 * @property string $text
 * @property string $img
 */
class GenNews extends CActiveRecord
{
	/**
	 * @return string the associated database table name
	 */
	public function tableName()
	{
		return 'gen_news';
	}

	/**
	 * @return array validation rules for model attributes.
	 */
	public function rules()
	{
		// NOTE: you should only define rules for those attributes that
		// will receive user inputs.
		return array(
			array('publicationDate, title, summary, text, img', 'required'),
			array('title, img', 'length', 'max'=>255),
			// The following rule is used by search().
			// @todo Please remove those attributes that should not be searched.
			array('id, publicationDate, title, summary, text, img', 'safe', 'on'=>'search'),
		);
	}

	/**
	 * @return array relational rules.
	 */
	public function relations()
	{
		// NOTE: you may need to adjust the relation name and the related
		// class name for the relations automatically generated below.
		return array(
		);
	}

	/**
	 * @return array customized attribute labels (name=>label)
	 */
	public function attributeLabels()
	{
		return array(
			'id' => 'ID',
			'publicationDate' => 'Publication Date',
			'title' => 'Title',
			'summary' => 'Summary',
			'text' => 'Text',
			'img' => 'Img',
		);
	}

	/**
	 * Retrieves a list of models based on the current search/filter conditions.
	 *
	 * Typical usecase:
	 * - Initialize the model fields with values from filter form.
	 * - Execute this method to get CActiveDataProvider instance which will filter
	 * models according to data in model fields.
	 * - Pass data provider to CGridView, CListView or any similar widget.
	 *
	 * @return CActiveDataProvider the data provider that can return the models
	 * based on the search/filter conditions.
	 */
	public function search()
	{
		// @todo Please modify the following code to remove attributes that should not be searched.

		$criteria=new CDbCriteria;

		$criteria->compare('id',$this->id);
		$criteria->compare('publicationDate',$this->publicationDate,true);
		$criteria->compare('title',$this->title,true);
		$criteria->compare('summary',$this->summary,true);
		$criteria->compare('text',$this->text,true);
		$criteria->compare('img',$this->img,true);

		return new CActiveDataProvider($this, array(
			'criteria'=>$criteria,
		));
	}

	/**
	 * Returns the static model of the specified AR class.
	 * Please note that you should have this exact method in all your CActiveRecord descendants!
	 * @param string $className active record class name.
	 * @return GenNews the static model class
	 */
	public static function model($className=__CLASS__)
	{
		return parent::model($className);
	}
    /*
        
       $rows=$this->findAllByAttributes(array('cat_class_id'=>$ids));      
       $id=array();
         foreach($rows as $row) {
            $id[]=$row['service_id'];
           // $Orgid[]=$row['id'];
                      }              
         return $id;}
    
    */
    
    public function lastnews()
    {
        $rows = $this->findAll(array(
            'order'=>'publicationDate DESC',
            'limit'=>'2',
        ));
       // $this->render('LastPosts/' . $this->tpl, array('posts'=>$posts,      ));
           
         return $rows;
         }
         
         
         
      
  
}

# 排隊
## 規則
* 物件
    * 人
        * 方向
        * 位置 (constructor給定初始位置)
        * Walk() 用來修改場地
        * Is_walkable() 只要是0都可以走
        * 速度 (一次移動幾格)
        * Out_of_bound 已經走到超出範圍，不再被控制且可以被覆蓋
        * *可以考慮加入角色，男女至少會間隔1格*
    * 場地
        * 把簡單的小圖放大(例如1x1縮放成9x9)，蓋到圖上
        * -1 : 障礙物
        * 0 : 空位
        * 1 : 上面有人
        * *障礙物*

* Manager function (每個人動完之後才進到這個function)
    * 每個thread負責一個固定區域，如果有一格發生重疊，則隨機選取該重疊中所有元素之一，並把他更新到下個phase的該格且刪掉他舊的位子，其他的刪掉重疊
        

* 每一個GPU可以負責一群人，計算各自的行為
* 行為
    * 若該人四周無路可走，則停住不動
    * 只會往當前phase的空格走
    * 儲存每一個phase時各格同時被幾個點疊加，隨機計算他們的priority，讓priority最高的人可以走進去該位置，其他人需要退回

* Phase
    * 每一輪都會Output出當前的Graph，寫入到output file

* Phase可視與分析
    * 另外寫一個程式把phase變化變成可視的ASCII或著是網格圖，可以交給python
    * 可以使用溫度圖，分析人群聚集處
    * 分析兩phase間移動人數
    * 走出Map的人流量

* 流程圖
![image](https://hackmd.io/_uploads/H1qZjuOva.png)


* 結果評量與討論




* project : 
![IMG_0475](https://hackmd.io/_uploads/ryE7eMFDp.jpg)







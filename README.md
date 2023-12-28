# 排隊

## 規則

- 物件

  - 人
    - 方向
    - 位置 (constructor 給定初始位置)
    - Walk() 用來修改場地
    - Is_walkable() 只要是 0 都可以走
    - 速度 (一次移動幾格)
    - Out_of_bound 已經走到超出範圍，不再被控制且可以被覆蓋
    - _可以考慮加入角色，男女至少會間隔 1 格_
  - 場地
    - 把簡單的小圖放大(例如 1x1 縮放成 9x9)，蓋到圖上
    - -1 : 障礙物
    - 0 : 空位
    - 1 : 上面有人
    - 定義大小為 64\*64，讀取大小為 16*16，每格會做 2*2 的縮放
    - _障礙物_

- Manager function (每個人動完之後才進到這個 function)

  - 每個 thread 負責一個固定區域，如果有一格發生重疊，則隨機選取該重疊中所有元素之一，並把他更新到下個 phase 的該格且刪掉他舊的位子，其他的刪掉重疊

- 每一個 GPU 可以負責一群人，計算各自的行為
- 行為

  - 若該人四周無路可走，則停住不動
  - 只會往當前 phase 的空格走
  - 儲存每一個 phase 時各格同時被幾個點疊加，隨機計算他們的 priority，讓 priority 最高的人可以走進去該位置，其他人需要退回

- Phase

  - 每一輪都會 Output 出當前的 Graph，寫入到 output file

- Phase 可視與分析

  - 另外寫一個程式把 phase 變化變成可視的 ASCII 或著是網格圖，可以交給 python
  - 可以使用溫度圖，分析人群聚集處
  - 分析兩 phase 間移動人數
  - 走出 Map 的人流量

- 流程圖
  ![image](https://hackmd.io/_uploads/H1qZjuOva.png)

- 結果評量與討論

- project :
  ![IMG_0475](https://hackmd.io/_uploads/ryE7eMFDp.jpg)

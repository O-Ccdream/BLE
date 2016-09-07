BLE 学习以及仿写nearlock功能心得
==
蓝牙知识学习
-----
随着蓝牙低功耗技术BLE（Bluetooth Low Energy）的发展，蓝牙4.0已经在大部分设备上被使用，好了，关于BLE的介绍就废话这么多。

---
###初衷
机缘巧合看到了一篇关于MAC与iPhone一起有什么妙用的文章，『excuse me?? 还有我大iOS猿类不知道的用法』最后被狠狠打脸，其中有个nearlock，『我艹，我艹，好用，NB』，作为一个充满好奇心快两年没有打开过IDE的不知道是项目经理还是产品经理总之就是程序员最恨的那个傻逼，自然研究了一下原理，『哦？蓝牙，智能硬件的雏形么这不就是，我也试试』（其实是因为nearlock全功能版需要付费！！25RMB！excuse me 钱这么好挣？？），初衷以2B形式完结。

---
###CoreBluetooth介绍
CoreBluetooth框架里其实就两个东西，一个外设（peripheral）一个中心（central），他们分别有对应的API如下图：
![](http://img.blog.csdn.net/20140523195339187?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvcG9ueV9tYWdnaWU=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)

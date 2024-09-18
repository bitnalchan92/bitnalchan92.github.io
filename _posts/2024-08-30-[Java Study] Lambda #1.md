---
title: "[Java Study] Lambda #1"
description: "기본 개념들"
author: bitnalchan92
date: 2024-08-30
categories: [java]
tags: [lambda]
pin: false
math: false
mermaid: true
---



# Lambda

## 개념

- 람다식은 메서드를 하나의 식으로 표현한 것
- 람다식은 단 1개의 추상메서드로 구성된 인터페이스의 구현 객체만 람다식으로 표현이 가능
  - 위 인터페이스를 함수형 인터페이스(Functional Interface)라고 한다.
- annotation은 @FunctionalInterface를 붙이는데, 이는 선택사항으로 두 개 이상의 추상메서드가 선언되면 컴파일 오류가 발생
- 람다식은 함수형 인터페이스를 아래와 같은 연산식 형태로 표현한 것



## 형식

```java
// ( 타입 매개변수 ) -> { 실행문; 실행문; ... }
//	    선언부    연산자      구현부

() -> {
  ...
}
```

1. 매개변수 타입은 실행 도중에 대입하는 값에 따라 자동으로 추론하기 때문에 타입 생략이 가능
2. 매개변수가 하나 있다면 괄호 생략이 가능하지만, 매개변수가 없다면 생략 불가
3. 실행문이 하나라면 중괄호 생략 가능 ( 실행문이 하나의 return문이라면 return키워드도 생략할수 있음 )
4. 람다식의 반환 타입은 문맥에서 추론할 수 있으므로 표현하지 않는다.



## 연습

### 샘플

```java
package bitnalchan92

@FunctionalInterface
public interface Parse { 
    boolean isSame(String a, String b);
}
```

```java
package bitnalchan92

public class Parse_Lambda {
    public static void main(String[] args) {
        Parse p;

        // 인터페이스 익명 구현 객체
        p = new Parse() {
            @Override
            public boolean isSame(String a, String b) {
                return a.equals(b);
            }
        };
        System.out.println(p.isSame("a", "b"));

        p = (String a, String b) -> {
            return a.equals(b);
        };
        System.out.println(p.isSame("c", "c"));

        p = (a, b) -> a.equals(b);
        System.out.println(p.isSame("d", "e"));

        // ✨ 아래 문장은 익숙하진 않네...
        p = String::equals;
        System.out.println(p.isSame("f", "f"));
    }
}
```



<p class="codepen" data-height="300" data-default-tab="html,result" data-slug-hash="ExBrJQR" data-pen-title="Untitled" data-user="bitnalchan92" style="height: 300px; box-sizing: border-box; display: flex; align-items: center; justify-content: center; border: 2px solid; margin: 1em 0; padding: 1em;">
  <span>See the Pen <a href="https://codepen.io/bitnalchan92/pen/ExBrJQR">
  Untitled</a> by Banghakdong_Tobagee (<a href="https://codepen.io/bitnalchan92">@bitnalchan92</a>)
  on <a href="https://codepen.io">CodePen</a>.</span>
</p>
<script async src="https://cpwebassets.codepen.io/assets/embed/ei.js"></script>


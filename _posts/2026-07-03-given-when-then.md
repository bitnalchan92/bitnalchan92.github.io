---
title: "Given-When-Then 자세히 이해하기"
date: 2026-07-03 07:30:00 +0900
categories: [Development, Testing]
tags: [BDD, Given-When-Then, Gherkin, Cucumber, Test, 테스트]
author: bitnalchan92
description: "Martin Fowler의 Given When Then 글을 바탕으로 BDD 테스트 구조와 실무 적용 방법을 정리합니다."
image:
---

최근 테스트 코드를 다시 정리하면서 `Given-When-Then`이라는 표현을 자주 보게 됐다. 단위 테스트를 작성할 때는 보통 `given`, `when`, `then` 주석을 나누거나, 테스트명을 한글로 길게 작성하는 정도로만 사용했는데, 이 방식이 정확히 어떤 배경에서 나온 것인지 궁금해졌다.

그래서 Martin Fowler의 [Given When Then](https://martinfowler.com/bliki/GivenWhenThen.html) 글을 읽어보았다. 글 자체는 길지 않지만, 테스트를 단순 검증 코드가 아니라 **시스템의 동작을 설명하는 예시**로 바라보는 관점이 잘 담겨 있었다.

이번 글에서는 Fowler의 글을 바탕으로 Given-When-Then이 무엇인지, BDD와 어떤 관련이 있는지, 그리고 실제 테스트 코드에서는 어떻게 적용하면 좋을지 정리해보자.

---

# Given-When-Then이란?

Given-When-Then은 테스트나 시나리오를 아래 세 단계로 나누어 표현하는 방식이다.

```text
Given  어떤 상황이 주어졌을 때
When   사용자가 어떤 행동을 하면
Then   어떤 결과가 나와야 한다
```

Fowler는 Given-When-Then을 테스트를 표현하는 하나의 스타일이라고 설명한다. 조금 더 BDD답게 말하면, 테스트를 통해 **시스템의 행동을 명세하는 방식**이라고 볼 수 있다.

즉, 테스트를 단순히 “이 값이 맞는지 확인하는 코드”로만 보는 것이 아니라, 아래처럼 읽히게 만드는 것이다.

```text
이런 상황에서,
이 행동을 하면,
이런 결과가 나와야 한다.
```

이 구조는 BDD, 즉 Behavior-Driven Development에서 자주 사용된다. Cucumber 같은 테스트 프레임워크에서도 많이 볼 수 있고, 꼭 Cucumber를 쓰지 않더라도 단위 테스트나 통합 테스트를 정리할 때 충분히 활용할 수 있다.

---

# Given: 테스트 시작 전 상태

`Given`은 테스트하려는 행동이 실행되기 전에 이미 주어진 상태를 의미한다.

예를 들어 알바 급여 계산 기능을 테스트한다고 해보자.

```gherkin
Given 민수는 시급 10,000원인 알바생이다
And 민수는 7월 1일에 8시간 근무했다
And 해당 근무 기록은 승인되었다
```

이 부분은 “테스트를 시작하기 전에 세상이 어떤 상태인가?”를 설명한다.

개발 코드로 보면 보통 테스트 데이터를 준비하는 단계다.

```java
Employee employee = new Employee("민수", 10_000);
Worklog worklog = new Worklog(employee, LocalDate.of(2026, 7, 1), 8);
worklog.approve();
```

Fowler는 Given을 테스트의 사전 조건, 즉 `pre-condition`으로 생각할 수 있다고 설명한다. 다만 테스트 프레임워크 입장에서는 Given이 단순한 설명이 아니라, 시스템을 해당 상태로 만들기 위한 명령들의 집합처럼 동작할 수 있다.

그래서 다른 테스트 패턴에서는 Given에 해당하는 부분을 `setup` 또는 `arrange`라고 부르기도 한다.

---

# When: 테스트하려는 행동

`When`은 실제로 테스트하고 싶은 핵심 행동이다.

```gherkin
When 7월 급여를 계산하면
```

여기서 중요한 점은 `When`은 가능하면 하나의 행동에 집중해야 한다는 것이다.

예를 들어 아래처럼 작성하면 테스트가 무엇을 검증하려는지 흐려질 수 있다.

```gherkin
When 알바생을 등록하고
And 근무 기록을 제출하고
And 사장이 승인하고
And 급여를 계산하면
```

이 경우 알바생 등록, 근무 기록 제출, 승인, 급여 계산이 모두 테스트 대상처럼 보인다. 하지만 이 시나리오에서 검증하고 싶은 것이 “급여 계산”이라면 앞의 과정은 `Given`으로 보내는 것이 더 자연스럽다.

```gherkin
Given 민수는 시급 10,000원인 알바생이다
And 민수의 8시간 근무 기록이 승인되었다

When 7월 급여를 계산하면

Then 급여는 80,000원이어야 한다
```

이렇게 나누면 테스트의 의도가 훨씬 분명해진다.

---

# Then: 기대하는 결과

`Then`은 `When`에서 실행한 행동 때문에 기대되는 결과를 설명한다.

```gherkin
Then 민수의 7월 급여는 80,000원이어야 한다
And 급여 상태는 지급대기여야 한다
```

개발 코드에서는 assertion에 해당한다.

```java
assertThat(payroll.getAmount()).isEqualTo(80_000);
assertThat(payroll.getStatus()).isEqualTo(PENDING);
```

Fowler는 `Then`에 해당하는 명령은 부작용이 없어야 한다고 말한다. 즉, 검증 단계에서 시스템 상태를 또 바꾸면 안 된다.

반대로 아래처럼 검증 단계에서 상태를 변경하는 것은 좋지 않다.

```java
result.markAsPaid();
assertThat(result.getStatus()).isEqualTo(PAID);
```

`Then`은 어디까지나 확인하는 단계이지, 새로운 행동을 수행하는 단계가 아니다.

---

# BDD에서 왜 중요할까?

Given-When-Then은 BDD에서 자주 등장한다. BDD는 테스트를 개발자만 보는 코드가 아니라, 기획자나 도메인 담당자도 이해할 수 있는 **행동 명세**로 바라본다.

예를 들어 아래 테스트 코드는 개발자 입장에서는 충분히 이해할 수 있다.

```java
@Test
void calculatePayroll() {
    Employee employee = new Employee("민수", 10_000);
    Worklog worklog = new Worklog(employee, 8);
    worklog.approve();

    Payroll payroll = payrollService.calculate(employee);

    assertThat(payroll.getAmount()).isEqualTo(80_000);
}
```

하지만 비개발자가 읽기에는 아무래도 부담스럽다. 반면 Given-When-Then으로 표현하면 비즈니스 규칙이 더 잘 드러난다.

```gherkin
Given 민수는 시급 10,000원인 알바생이다
And 민수는 8시간 근무했다
And 근무 기록은 승인되었다

When 민수의 급여를 계산하면

Then 급여는 80,000원이어야 한다
```

이렇게 작성하면 이 테스트는 단순한 코드가 아니라 하나의 요구사항처럼 읽힌다.

> 승인된 근무 기록이 있으면, 시급과 근무 시간에 따라 급여가 계산되어야 한다.

이 점이 Given-When-Then의 가장 큰 장점이라고 느껴졌다.

---

# Cucumber와 Gherkin

Fowler의 글에서도 Cucumber 이야기가 나온다. Cucumber는 비즈니스 시나리오를 테스트로 연결할 수 있게 해주는 도구이고, 이때 사용하는 DSL 이름이 `Gherkin`이다.

Gherkin 문법에서는 아래와 같은 구조를 자주 볼 수 있다.

```gherkin
Feature: 급여 계산

Scenario: 승인된 근무 기록만 급여 계산에 포함된다
  Given 민수는 시급 10,000원인 알바생이다
    And 민수는 7월 1일에 8시간 근무했다
    And 해당 근무 기록은 승인되었다
    And 민수는 7월 2일에 5시간 근무했다
    And 해당 근무 기록은 아직 승인되지 않았다

  When 7월 급여를 계산하면

  Then 민수의 급여는 80,000원이어야 한다
    And 미승인 근무 기록은 급여에 포함되지 않아야 한다
```

여기서 중요한 것은 Cucumber를 써야만 Given-When-Then을 사용할 수 있는 것은 아니라는 점이다.

Fowler도 이 스타일은 Cucumber 같은 프레임워크에서 많이 쓰이지만, 어떤 종류의 테스트에도 사용할 수 있다고 설명한다. 실제로 JUnit 테스트 코드 안에서 주석으로 나눠 사용하는 것도 충분히 좋은 방식이다.

```java
@Test
void 승인된_근무기록만_급여_계산에_포함된다() {
    // given
    Employee minsu = new Employee("민수", 10_000);

    Worklog approvedWorklog = new Worklog(minsu, LocalDate.of(2026, 7, 1), 8);
    approvedWorklog.approve();

    Worklog pendingWorklog = new Worklog(minsu, LocalDate.of(2026, 7, 2), 5);

    // when
    Payroll payroll = payrollService.calculateMonthlyPayroll(minsu, YearMonth.of(2026, 7));

    // then
    assertThat(payroll.getAmount()).isEqualTo(80_000);
}
```

---

# Arrange-Act-Assert와의 관계

Given-When-Then은 완전히 새로운 개념이라기보다, 기존 테스트 구조를 더 비즈니스 친화적인 언어로 표현한 것에 가깝다.

테스트 코드에서 많이 쓰는 `Arrange-Act-Assert`와 비교하면 아래처럼 대응된다.

| Given-When-Then | Arrange-Act-Assert | 의미                            |
| --------------- | ------------------ | ------------------------------- |
| Given           | Arrange            | 테스트에 필요한 상태를 준비한다 |
| When            | Act                | 테스트하려는 행동을 실행한다    |
| Then            | Assert             | 기대한 결과를 검증한다          |

또 Fowler는 `Four-Phase Test`와도 연결해서 설명한다.

| Given-When-Then | Four-Phase Test | 의미                        |
| --------------- | --------------- | --------------------------- |
| Given           | Setup           | 테스트 상태를 준비한다      |
| When            | Exercise        | 테스트 대상 동작을 실행한다 |
| Then            | Verify          | 결과를 검증한다             |
| -               | Teardown        | 테스트 후 정리한다          |

BDD 스타일에서는 보통 `Teardown`이 겉으로 잘 드러나지 않는다. 테스트 프레임워크나 트랜잭션 롤백, 자동 정리 기능이 처리하는 경우가 많기 때문이다.

---

# 실무에서 적용할 때 주의할 점

## Given에는 필요한 조건만 둔다

테스트를 작성하다 보면 필요한 것보다 많은 데이터를 Given에 넣고 싶어질 때가 있다.

```gherkin
Given 직원이 있고
And 사업장이 있고
And 사장이 있고
And 직원의 전화번호가 있고
And 직원의 주소가 있고
And 직원의 생년월일이 있고
When 급여를 계산하면
Then 급여가 계산된다
```

하지만 급여 계산에 전화번호, 주소, 생년월일이 필요 없다면 Given에 넣지 않는 것이 좋다. 불필요한 정보가 많아질수록 테스트의 핵심 의도가 흐려진다.

더 좋은 방식은 아래처럼 테스트하려는 규칙에 필요한 조건만 남기는 것이다.

```gherkin
Given 직원의 시급은 10,000원이다
And 승인된 근무 시간이 8시간이다
When 급여를 계산하면
Then 급여는 80,000원이어야 한다
```

## When은 하나의 핵심 행동으로 둔다

When에 여러 행동이 섞이면 테스트가 실패했을 때 원인을 파악하기 어렵다.

```gherkin
When 알바생을 등록하고
And 근무 기록을 만들고
And 승인하고
And 급여를 계산하면
```

이런 경우에는 등록, 기록 생성, 승인은 Given으로 보내고, 실제 검증 대상인 급여 계산만 When에 두는 것이 좋다.

```gherkin
Given 알바생이 등록되어 있다
And 승인된 근무 기록이 있다
When 급여를 계산하면
Then 예상 급여가 계산되어야 한다
```

## Then은 상태 변경 없이 검증만 한다

Then 단계에서는 결과 확인만 해야 한다. 검증 도중에 상태를 바꾸면 테스트가 읽기 어려워지고, 테스트 실패 원인도 모호해진다.

```java
// then
assertThat(payroll.getAmount()).isEqualTo(80_000);
assertThat(payroll.getStatus()).isEqualTo(PENDING);
```

Then은 결과를 만드는 곳이 아니라, 이미 만들어진 결과를 확인하는 곳이다.

---

# 테스트 이름에 적용하기

JUnit 테스트를 작성할 때도 Given-When-Then 흐름을 테스트 이름에 반영할 수 있다.

```java
@Test
void givenApprovedWorklog_whenCalculatePayroll_thenReturnsCorrectAmount() {
    // given
    Employee employee = new Employee("민수", 10_000);
    Worklog worklog = new Worklog(employee, 8);
    worklog.approve();

    // when
    Payroll payroll = payrollService.calculate(employee);

    // then
    assertThat(payroll.getAmount()).isEqualTo(80_000);
}
```

다만 개인적으로는 한국어 테스트명도 꽤 괜찮다고 생각한다. 특히 도메인 규칙을 표현해야 하는 테스트라면 아래처럼 작성하는 편이 더 읽기 좋을 때가 많다.

```java
@Test
void 승인된_근무기록이_있으면_급여를_정확히_계산한다() {
    // given
    Employee employee = new Employee("민수", 10_000);
    Worklog worklog = new Worklog(employee, 8);
    worklog.approve();

    // when
    Payroll payroll = payrollService.calculate(employee);

    // then
    assertThat(payroll.getAmount()).isEqualTo(80_000);
}
```

테스트명만 봐도 정책이 보인다.

- 승인된 근무 기록이 있으면
- 급여를 정확히 계산한다

이런 테스트가 쌓이면 테스트 코드 자체가 문서 역할을 하게 된다.

---

# 알바페이에 적용해본다면

알바페이 같은 서비스에는 Given-When-Then이 꽤 잘 맞는다. 급여, 근무 기록, 승인, 반려, 지급일 같은 도메인 규칙이 시나리오로 표현하기 좋기 때문이다.

예를 들어 아래와 같은 기능이 있다고 해보자.

> 알바생은 이번 달 예상 급여를 확인할 수 있다.

이 요구사항을 Given-When-Then으로 풀면 아래처럼 정리할 수 있다.

```gherkin
Feature: 예상 급여 조회

Scenario: 승인된 근무 기록만 예상 급여에 포함된다
  Given 민수는 시급 10,000원인 알바생이다
    And 민수는 이번 달에 승인된 8시간 근무 기록을 가지고 있다
    And 민수는 이번 달에 미승인 5시간 근무 기록을 가지고 있다

  When 민수가 이번 달 예상 급여를 조회하면

  Then 예상 급여는 80,000원이어야 한다
    And 미승인 근무 기록은 예상 급여에 포함되지 않아야 한다
```

이 시나리오를 먼저 정리하면 구현 전에 정책을 분명히 할 수 있다.

- 미승인 근무 기록을 포함할 것인가?
- 반려된 근무 기록은 어떻게 처리할 것인가?
- 지급 완료 후 추가 승인된 기록은 어느 달 급여에 반영할 것인가?
- 야간 수당, 주휴 수당, 휴게 시간은 어떤 순서로 계산할 것인가?

결국 Given-When-Then은 테스트 작성 방식이기도 하지만, 요구사항을 더 구체적으로 만드는 도구이기도 하다.

---

# 정리

Martin Fowler의 Given-When-Then 글을 읽고 나서 가장 크게 느낀 점은, 이 방식이 단순한 테스트 주석 스타일이 아니라는 것이다.

```text
Given  상황을 준비하고
When   행동을 실행하고
Then   결과를 검증한다
```

이 구조를 사용하면 테스트가 더 읽기 쉬워지고, 비즈니스 규칙도 더 선명하게 드러난다.

특히 도메인 규칙이 중요한 서비스에서는 테스트 코드가 곧 문서가 될 수 있다. 테스트가 실패했을 때도 단순히 “코드가 깨졌다”가 아니라, “어떤 비즈니스 규칙이 깨졌다”에 가깝게 이해할 수 있다.

앞으로 테스트를 작성할 때는 단순히 `given`, `when`, `then` 주석을 붙이는 데서 끝내지 않고, 각 단계가 정말 자기 역할을 하고 있는지 확인해봐야겠다.

- Given에는 필요한 사전 조건만 있는가?
- When은 하나의 핵심 행동인가?
- Then은 상태 변경 없이 결과만 검증하는가?
- 테스트 이름이 비즈니스 규칙을 설명하고 있는가?

이 네 가지를 지키는 것만으로도 테스트의 가독성과 유지보수성이 꽤 좋아질 것 같다.

---

# 참고

- [Martin Fowler - Given When Then](https://martinfowler.com/bliki/GivenWhenThen.html)
- [Cucumber - Gherkin Reference](https://cucumber.io/docs/gherkin/reference/)

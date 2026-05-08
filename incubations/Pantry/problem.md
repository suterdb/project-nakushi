# Problem Definition — Pantry

## Who

People who cook at home — especially single or two-person households — who have ingredients on hand but struggle to adapt recipes to what they actually own.

## What

Existing recipe services deliver recipes as static lists. When a user is missing an ingredient, the service offers no guidance: they don't know if the ingredient is essential, replaceable, or safely skippable. The result is either a wasted trip to the store or giving up on cooking entirely.

## Why now

Rising food prices have increased the motivation to cook at home. Interest in cooking has grown through media, but the tools available still stop at "here is a recipe" — they never answer "can I make this *with what I have*?"

## Root cause

Recipe services are ingredient-agnostic. They have no concept of the user's pantry, and therefore cannot reason about substitution, omission, or purchase priority. The personalization layer is entirely missing.

## Success definition

A lightweight AI model (Haiku-class) with a well-tuned prompt can classify recipe ingredients into essential / substitutable / omittable with quality good enough to be genuinely useful — without requiring a larger, more expensive model.

---

## 한글 버전

## 대상 사용자

1인·2인 가구를 중심으로, 냉장고에 재료는 있지만 레시피를 자신의 상황에 맞게 변주하지 못하는 사람들.

## 겪는 문제

현재 레시피 서비스는 재료 목록을 정적으로 제공한다. 재료가 없을 때 필수인지, 대체 가능한지, 생략해도 되는지 안내하지 않는다. 결과적으로 마트에 가거나 요리를 포기하게 된다.

## 지금 해야 하는 이유

고물가로 직접 요리 필요성이 높아졌다. 요리에 대한 관심은 증가했지만, 기존 서비스는 "레시피 전달"에서 멈춘다. "내 재료로 만들 수 있나?"를 답해주는 서비스가 없다.

## 근본 원인

레시피 서비스는 사용자의 냉장고를 모른다. 개인화 레이어(필수/대체/생략 분류)가 존재하지 않는다.

## 성공 정의

Haiku급 경량 모델 + 프롬프트 튜닝만으로, 재료 분류(필수/대체/생략) 품질이 실제로 유용한 수준임을 검증한다.

---
header:
  overlay_image: /assets/images/header-learn.jpeg
title: "How to learn new skills, without magic promises"
categories:
  - tech
  - opinion
tags:
  - linux
  - problem-solving
  - programming
  - creativity
  - learning
  - skills
  - devops
---
"Professor", my colleague  asks me jokingly, "Why don't you write a blog about how I can learn Javascript." That got me thinking, since I am eternally learning new things, always studying something: Music theory, playing an instrument, Spanish, Turkish, Math, Programming, and the list goes on. Have I learned anything about the process of learning? Did I distill any rules that I now apply either consciously or unconsiously?

The question of how to learn is asked by many, but only few of us actually listen to the answers, and even fewer of us put them into practice. That is because even if you do all the right things, the right ways (assuming we could clearly define those) it still costs us. It takes effort, time, energy, focus. And for us working people with a life that means it takes up space in a life that is already full and something will need to give. You can learn effectively, sure, but here is the first consideration: There are no shortcuts.

## 1. There are no shortcuts

><div style="width:100%;height:0;padding-bottom:75%;position:relative;pointer-events:none;"><iframe src="https://giphy.com/embed/TZjY28zYHoize" width="100%" height="100%" style="position:absolute" frameBorder="0" class="giphy-embed" allowFullScreen></iframe></div>
><cite>[Or maybe...][dexter]</cite>

While there are things to avoid, and things to strive for it is good to be as realistic as possible with your expectations. You want to learn javascript in three weeks? Well of course you can spend three weeks learning javascript, but chances of you mastering it are very slim, and even that might still be an exaggeration. You will have to put in the effort, and understanding this before you start gives you a much better chance at achieving your goals.

## 2. Set yourself a goal
This is an obvious one, that you probably have seen everywhere. Goal setting. Now before you do this, let's think a bit about why that would be useful and what kind of goals are helpful. In fact is it true that any goal is better than none? Any goal is a good goal ? I beg to differ. Goals are points at the horizon. You define them, so you have something to look at, a point on which to focus so that your energy and efforts are getting aligned with achieving that goal. And that means there are do's and don'ts!

A goal that is to big, or in terms of our image of the "horizon": too far.. is a goal that will not help you. It is a dream to keep dreaming about, but if you put it that far, it is past the horizon, you can not see it so it will not help you focus and thinking about the work necessary to achieve it will only paralyze and / or demotivate you.

A goal that is too small, or "too close", will not be interesting enough, ambitious enough, to inspire you to do the work... and therefore the unintuitive result is that goals that like this are also hard to achieve!

A good goal should be in the middle, ambitious enough to scare you a bit, to make you feel excited and a bit anxious. At the same time it should be attainable, you should be able to imagine the necessary work and effort it will cost you. You should see it at the horizon, so you can direct yourself towards it.

And since setting goals, as well as achieving is a habit that is trained, the goals naturally become more audacious as you continue. There is no fun in staying safe folk
!

## 3. Get support
As said in the beginning, it takes time, effort, and focus. So unless your life is empty and boring now, that means some other parts of your life will have to give that space. Trying to learn something new, without changing anything in your life is doomed to fail. Talk to your partner, talk to your colleagues, talk to your employer, talk to your friends. If people support you, and help you that is a great advantage, a super power you have got there. If they don't then it is up to you to decide: either you still go for it, and others, while not supportive will at least know what you're working for and why that changes the way you spend your time and energy. Or decide to just not do it.

I'll say it again, trying to learn something without creating this space, without a way to even put in the necessary work is a really good way to cheat yourself and then be disappointed.

## 4. Get in the game
>Live as if you were to die tomorrow. Learn as if you were to live forever.
><cite>Mahatma Gandhi</cite>

You still did not get to do all before mentioned points, so you're waiting for the right moment? Waiting until work gets calmer? Waiting until new year ? Be careful: you will do what you practice, always. So be afraid to practice procrastination! Just stop pretending you will get to it. And when you are serious about it, when you feel enthousiasctic about learning something new: do it. Sort out a way to get started and get in the game. Tweak  the other points as you go. Preparation is great, but it does not have to be perfect!

## 5. Immerse yourself
Learning something by doing it an hour a time, two times a week is very, very hard. You will find that you are wasting a lot of time and energy bringing back up what you already learned, what you were doing. If you want to learn effectively it is much better to take a period in which you spend as much time on it as possible. Don't try to learn five things at the same time. Choose one, and immerse yourself as much as possible. This is why #3 is important!.

Immersion will also speed up learning, and that will do all kinds of wonderful things: You notice you're improving which fuels enthousiasm. It can bring you to a point where the subject really becomes central in your thoughts. And while that may make you somewhat less attentive to other things, it fortifies your learning massively. Learning something is all about associations. The more associations you create in your brain, the stronger. As a simple example: Say you're learning coding, and you already know how to play some guitar. At some point, if you may get to the point that you go to rehearsal with your friends and suddenly it occurs to you that the guitar solo is just:
```
const base_sequence = "Am Am G"
for (let i = 1, i<=8, i++) {
  if i%2 == 1 { // i the uneven rounds
    const play(base_sequence + "E7")
  else {
    const play(base_sequence + "Am")
    }
  }
}
```

Or what about the days:
{% include code-header.html %}
```
public abstract class Day {
  boolean breakfast = true;

  boolean kidsGoToSchool;

  String todaysCook = "Mom";

  public void brushYourTeeth() {
    System.out.println("Kids come brush your teeeeeeeth!");
  }
}
```
{% include code-header.html %}
```
public class Monday extends Day {
  boolean kidsGoToSchool = true;
  String todaysCook = "Dad";

  public static void main(String... args) {
    Day today = new Monday();
    System.out.println(today.breakfast);
    System.out.println(today.todaysCook == "Dad"); // is it ?
    System.out.println(today.kidsGoToSchool);
    today.brushYourTeeth();
  }
}
```
These type of associations and abstractions will come as a result of immersing yourself. It is then that your learning continues throughout the day, also when doing completely different things. It is a very powerful tool to accelerate and solidify your learning.


We all marvel at the way kids seem to learn things effortlessly and quick. Well, did you ever try to observe how many hours of their waking day are spend going back and forth through the alphabet? How many times the repeat their multiplication tables? Riding a bike? Right: Now imagine sitting down working through your lessons in Java for as long as you see your kids doing any of these. Would you learn faster then you would now? You betcha! (But yes, please observe #3 or I will get angry comments from abandoned loved ones!)

## 6. Fake it 'till you make it
We generally know is important, recommend it to others, but fail to apply it to ourselves. Did you ever meet anyone from another country that is now learning your language? "Just go out and practice. Talk to people, that is a great way to learn". This is often the first advice given.

So what about when you learn something new, Docker for example, then what ? Here is one of the most scary and at the same time most effective suggestions I have for you: Get involved in [Stack Overflow][so]. And I mean _involved_. Create an account. (You would be surprised how many of us techies use Stack Overflow all day every day, but never bothered to make an account!). Before anything else: take 5 minutes to familiarize yourself with the [community guidelines][guidelines]. You'll be disappointed if you don't! Then there are three things to do:
1. Search for questions on the subject you are learning (use the filters for that). You can filter on `highest score` and you will without exception find questions and answers that will teach you something new, dive just that bit deeper into the subject you are busy with!
2. Ask questions: Asking good questions is a valuable skill, so train it! Also in accordance with Stack Overflow's ["How to ask a good question"][ask] setting up a minimal reproducible example solves half of your problems without asking, and for the other half you will learn to view your issue from another side, and when you get answers they will not only fix the problem you had, but teach you something more general about the topic as well.
3. This is the most important: Filter on `newest` and find questions that you know the answer to. Or think you know. Or think you should know. And then go ahead and _answer them_. This again costs you some time and effort but I assure you it is worth it: You will research just a bit more, and force yourself to organise your thoughts, reaffirming what you're learning again. And also: you will see that quite quickly you are able to actually help others and you find you know more than you thought! If you're like me, then you'll find it very motivating to continue.

On that same note: I recently upped this game for myself. Browse around on this blog and you will see a bunch of topics I wrote about even though most likely there are others who are more knowledgeable. Why? Because for one, I do not want to forget what I just spend days figuring out, and two after writing it all down I invariably learn more about it: To get all the steps and lines in place I want to make sure it is correct.. _and why_.

On many occasions we are satisfied with knowing _something works_. "Fake it 'till you make it" makes sure we also dig into _why it works_. An added bonus is that I get to learn because of [other people's tips and suggestions][reddit]!

***Pro tip: There are many ways to put this principle into practice: Take up relevant tasks at work, create a project for yourself or with friends/colleagues, give a presentation ... .. .***

## 7. Have fun
Learning something only so that you can enjoy it, after you have mastered it makes no sense. I repeat: No sense, at all. Why would you enjoy it when you are good at it... when you do not even enjoy it when it is a shiny new adventure ? That does not happen. So allow yourself to have fun, and when it weighs on you: take a break. Don't stop, just take a break and relax, or shift your attention on something on the side. You're frustrated because the RxJs excercise just does not seem to work no matter what you do ? Relax, take a coffee read a it on Reddit, maybe someone writes something interesting about Reactive Programming in Java (Wow is that a thing?, interesting...!). This way, you keep immersed, you keep busy... and you can because it keeps being fun!

## Conclusion
If you hoped I had some super trick to learn anything you want in a breeze you might be a bit demoralized now. If so: I do not apologize. I did not make it that way, I am just telling it the way I see it. If you're serious about learning stuff then hopefully you found something here to inspire you to take the next step. It may not be easy, but at least it is simple; After all, if you want to get to that spot on the horizon, you can do it:
```
While not at goal:
  Take the step in front of me.
```

[so]: https://stackoverflow.com/
[dexter]: https://youtu.be/2kArCRjT29w
[reddit]: https://www.reddit.com/r/linux/comments/t3dxio/blog_terminal_file_managers_and_my_vifm_setup/?utm_source=share&utm_medium=web2x&context=3
[guidelines]: https://stackoverflow.com/conduct
[ask]: https://stackoverflow.com/help/how-to-ask

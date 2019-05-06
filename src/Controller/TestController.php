<?php

declare(strict_types=1);

namespace App\Controller;

use App\Message\TestMessage;
use Sensio\Bundle\FrameworkExtraBundle\Configuration\Route;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Messenger\MessageBusInterface;

/**
 * @author Issei Murasawa <issei.m7@gmail.com>
 */
class TestController extends AbstractController
{
    /**
     * @Route("/enqueue", methods={"POST"})
     */
    public function enqueue(MessageBusInterface $bus): Response
    {
        $bus->dispatch((function () {
            $msg = new TestMessage();
            $msg->senderName = 'Issei.M';

            return $msg;
        })());

        return $this->json(['status' => 'ok']);
    }
}

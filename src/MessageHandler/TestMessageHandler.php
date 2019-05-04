<?php

declare(strict_types=1);

namespace App\MessageHandler;

use App\Message\TestMessage;
use Psr\Log\LoggerInterface;

/**
 * @author Issei Murasawa <issei.m7@gmail.com>
 */
class TestMessageHandler
{
    /**
     * @var LoggerInterface
     */
    private $logger;

    public function __construct(LoggerInterface $logger)
    {
        $this->logger = $logger;
    }

    public function __invoke(TestMessage $message)
    {
        $this->logger->info('Hi!, ' . $message->senderName);
        $this->logger->info('Start!');

        \sleep(5);

        $this->logger->info('Complete!');
    }
}